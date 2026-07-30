Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A331C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1DC6B00A3; Thu, 30 Jul 2026 10:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3276B00A5; Thu, 30 Jul 2026 10:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91016B00A7; Thu, 30 Jul 2026 10:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAF06B00A3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:30:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26E8E1401A0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:30:23 +0000 (UTC)
X-FDA: 85045678326.30.4E61742
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3290E180014
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:30:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hyg4LSr2;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PziV63Nbks27UfV1soZbzQSjz5qZMrsSwS8b4MFid6w=;
	b=pF226brc3i7Ri5yI9KRseefRa22FLbnDdsEtYdZIS/AtFL94O5zjvJGC5YY2IUldYA41Pn
	s5Lo7DZjT/SBc8ESPV4HTgGmo6wM02C8+uC/yzsUysco6ikxjYfGM+7yqXM+bW5NFJZ/ng
	t/TEGGyqs+X66tRdTSun/Fk61qVhKc0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421821;
	b=oMt0cWd4D6mLoHVRMUWlIMcrh070XZk764JOD2nyFzp5iPlsXap83D4j8RuyhRcGAb3Qrg
	2vEMebgLvZH+KTBNzuK0nye055iui2YhN2z/TvmmB/u7zvQPO5P56EkZa0+61IecjBAPtC
	b/i6pqKXE9pbXxqWadIwQjV5OCoHtRQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hyg4LSr2;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-455ee8f529dso456647fac.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785421820; x=1786026620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PziV63Nbks27UfV1soZbzQSjz5qZMrsSwS8b4MFid6w=;
        b=Hyg4LSr2qTrlIBf1UMMbcB2+SbWtv1vhj+lTfbMyqwvK+iE3feD9CUa6gqOnn7aCgu
         WNGqnv78GcSAZ5XCVnSaEHj1e3fehnfFv9XhuYOGSwDQlYHmvmj64+yqgJML1n8xV8t6
         sPiQHNbb6cZBrW/kkLWzKK7VC9JWti76Ll2mua4Zvb9gY07+MeGjGqzHHPJ145vDkY6A
         Q/GtMvxPQ/+Ot4AiCLzM7zeB6QIhE4cv0T8BSH0qzS0kDz3p8lSaiZm1nGKlFGwtmahp
         ndCJ0C7yzhYDGYC27HHOcL5sPKbXCJHdcLsOQyMU0vWPawyHyc1iKEH8R6YtrXg2L1b6
         675A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785421820; x=1786026620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PziV63Nbks27UfV1soZbzQSjz5qZMrsSwS8b4MFid6w=;
        b=sJMSjWnZu4fwcRLBMG/K4jJMA3hLjOphK5P64KWBxo8eRSqFcEqXRN0iOTevW9O1OH
         Youam/P8sL/qkDAFpzn7pZyA0mh/zdUwmUKgOEAgx3i6oGoC3n4HTUxoO4huTihcj0AA
         d+CuX8oDJb6rkkk48L2kFcQy2XEmORvHWOk23/Uu+bEXeLYfIGSx91WE/+s4j5jmldDO
         aFmFFzq4eHgwqK/tTA2mLGlPa9q11fhR9hXkopHC9ScSDbqb7zAHWZ5d56Pev0cx6bGm
         3BsJR0Ewy2qpPGj+bpKqvXOO4WvTGl1iJ9dYcyUATJa8QCGPPPlKkFNfJiPNKao7IYCu
         FFAA==
X-Forwarded-Encrypted: i=1; AHgh+RpM1a0/g9LexpcArPRVRN8YaYOW3TmfJeltY50ykB4vBOCSRzdHoAEBI2XrQmwWFTP/G65jyDUFGw==@kvack.org
X-Gm-Message-State: AOJu0YyjjlEFR+FHLXoaV8U5EmRTptuezc7S6zJLBtmpGOSxuSNRcOF3
	FeibJAKnWJXj1EnTVzJvqBuMZbuVrNdaTpxKF2joEu5wY9WoGwbM5oq4
X-Gm-Gg: AR+sD13JPPHwlY0j9s81DRqv7URIn3ihADcG3LuTM5sMn/shnO4Ull8qs0Dy22Y7+CG
	1Y8mA39tnexP8fdukGAfArJUDp8L4rY2zucM7G3DG+2r6D4vao2tsCEljbKhz/3IDQsExsQJqu6
	4Bu3aH03i/tqj4rOpK1DZ1v7Yil/WsGX/yNxsEjcWFOVK93xm0OAVBtIX7lTTdsuHJUudfGqrUI
	wV5G3ekgNtLi2/p1SqP4AGowprttNO5lsNETwwv5wZP4CHEGDHL8f3I/tMG2ESlUBi7Ct6l05o6
	nHYY0x94PIswBtYlATriSO2ZrVd136QDWsgA+BQf7A22SqlZOe2GYFPMN6d42J2L/52ic1h5Pr4
	OwJJacfj4awhEx4qJcXguia5cpC4lLGQok6drhEbjaOAn8jj/+HqLHZhLGQMZ7vQmvofdYriKO2
	NGtTOxGqQthtGU6otS+SyAmooA00dQPNPKrUlz4SY4mk2FpL+1nLudkqRlzdUkR1mcQl7OYagj/
	ytMwf/+CFonjtIvPupyAOC81epCfQ==
X-Received: by 2002:a05:6870:8263:b0:456:5582:19be with SMTP id 586e51a60fabf-458c1b24576mr1955115fac.38.1785421820045;
        Thu, 30 Jul 2026 07:30:20 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458c2947cc5sm1964872fac.11.2026.07.30.07.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 07:30:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev,
	lkp@intel.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	"Michal Hocko" <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	tim.c.chen@intel.com,
	vinicius.gomes@intel.com,
	ehab.ababneh@intel.com,
	thomas.falcon@intel.com,
	yu.c.chen@intel.com,
	philip.li@intel.com
Subject: Re: [PATCH v4 4/5] mm/memcontrol: convert memcg to use page_counter_stock
Date: Thu, 30 Jul 2026 07:30:16 -0700
Message-ID: <20260730143017.1568456-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <amr1lhRiYC64kYNY@xsang-desk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3290E180014
X-Stat-Signature: 5z6ah8am9uakanryzwiqx6pmuck5e8qq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785421821-118170
X-HE-Meta: U2FsdGVkX1/Sbzn8m17pv2wP1wAW8bDCDnSdsorNOLQNAinYeKTkkKaEyC6h2iONJqAWW3frA2PW3/FoVMouMP/kfZISkgdQ9oLSOls33EJ3EBUFEzrJ4sCV3q7dR6MfyQM9I3bJCCXQbe/zPiiL8ACEt3iMSaIFf/SGjvlavGfC/hVe7S1uHyiLGmduTayoh6wXL8mnixm3V5iW0VcDJlf/aIxwzNqwl60/T8woqmePwrdjfOWweL0rV54UZdcX5J4cjRgWpf0kLtnWNgEtJcxK6AR3AjS4rpQ56+yLqTOspsnPfjOW/eytxAOTnH83RadzEjrLbG1/tSOqo5IU0dQ7lv+qkvhATD3PR8nq+ZffzKag5q9Gf2ETTsxobPVXxuME4+nX7Y9DZDIYlI2nbUl8OJwSwIM1cUJL418y+zbwaFG0F04h6xGA41HslAwZeRvQD6/t1sTNYmpzR26Mt4sQyWAV8Z6ZwQURqyyAJisnuB9U10Qg47nKo+mAivvsjevnS5tLl6Uwutz3NeR4elS5bDuud/btLdDXp8TYB+mKLCXJ5MfJO2ftdIUdujOTduOKOX1Bb+bm4b6mugn/lp+rMPKIrQpMa4RQRvwV/fdBtP59gYT87S/T1rlqMAibiW0KPKJAcm1dnHrlRyRzAgkihfeGQhwbHVfPxmdJjKXNAMZP32v9mbqtlSStZdx/+Oj9SItETZKfIQmzCzbJ+atjvdix6+cYq5+6qMg2rnfI0/Bad5Px3KUgz6BPrBS2JarvgbZw+Mgvrf6t4DN6mn65gll7mRsBTczGLtXaPJWPYcoKCRMgLUdoYiQ5bGT3jUbTBfiQar5nisp5wXAq2Rhlu4QZtUiFSVfg9kvwlGDxC2Z21SA/oP2MXQTbv/B77Y5POBb0W4AEVARcWrai3c+IGPhZZJgqFeFfL/ifllbtYigHHQmC7POR/AcnrjAytk6OwP4oP+EqL75hwGF
 3ZcmLOTz
 6ledeCn2W3Qj3G7oI6QGW6eLeRViJBCKFKUoLCL5IHJVoLnzY1/Mj0PY8GHZ364R0uq9Id4ILYBG3YnpgAA0pRuUd6CwWMHKbLpWcsD+c0hJBtJtCbCAKlT03x8IxNGzJ82QZxtbml/QNMKMR94vBiFwvl6m5B80JaCqjh1dZr/Prk3RNx9dKn6jLJYuAqozEDVhDvAv8SoTnQknRxHij4CXPSZe65VwmsiGCIMRYECw5vVam/qtwudWtSPQP5UYk1P7T4WkuL12ciHqg1CY2NVEnsy8VzKiCq6nWICSNLXlHst0jMRbJogM/97T3bOS/oObd5hP9TIWIH7Crhj6xy6OVN7FxPU0GRXWj0CdOlzDeIRU5zliOt+3cmslgChJ71gtybAIgIqGG8CQjLQyj/KcgpA0ZyrEkymsZ+P1+H1PFTAiXrhIwBW5U34+YOc6P4eglctwLKKzuCk0UJO/SvyN09zUiiz67Dp9j8uGMLfoTEESrgPKLjtqouo/FNjiee4ASXzvxt2i0nzWDAe8HGIcLtsW5DtnwZTL1wZBZNu7Z/7M/DPGuLuhAcU/4NFJinRXHz+ilDAOMzj9GeyG+3R25cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 14:56:22 +0800 Oliver Sang <oliver.sang@intel.com> wrote:

> hi, Joshua Hahn,
> 
> we are currently piloting AI integrations to help enhance 0-Day's performance
> analysis and regression-detection capabilities. Since this is in an early trial
> phase, we want to ensure we build features that genuinely support your workflow.
> We would love to hear what you would like to see from AI-assisted reports, whether
> it's specific bottleneck explanations, a cleaner format, or filtering ideas.
> 
> Please share your thoughts and suggestions with us to help guide our development!
> 

Hello Oliver,

Thank you for this sample fix, and thank you for the report. It helped me
realize that uncharging should return stock, but only in the networking
side (and not the lru side, since it's already batched there).

This is a personal style preference but I like to keep reply context as
minimal as possible, I think that the AI response might not need to keep
all the performance statistics still in the reply at the end : -)

Otherwise I am a big fan of this (for my patches, at least) as an author.
I'm wondering if reviewers and maintainers may find this to be too noisy
to be sent out in the mailing list.

Thank you again, I hope you have a great day!
Joshua

