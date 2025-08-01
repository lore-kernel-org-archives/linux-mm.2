Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E93C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF54E6B008A; Fri,  1 Aug 2025 10:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA63E6B008C; Fri,  1 Aug 2025 10:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBBEE6B0092; Fri,  1 Aug 2025 10:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD8B16B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:50:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7AC7514012F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:50:42 +0000 (UTC)
X-FDA: 83728475124.17.E11B331
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 921D8140005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:50:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A3fHat3t;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754059840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjg07z5yf4Lf1nLCjxfxMn6+NFk9uurEps7NM4R0GOc=;
	b=xYZZLr61/CGglH4f1Gu+E2sq0sCgH9k19MO29qdZIpV9CgT2TJ/XvzyOG6nHbitz6KlJxv
	LnhQo6liAP1U9rs5/BAMlLxah/yKPLY6tg2XGrmuqMsBKt4krQCbJZn5ZNf4KmvmRqxlgj
	4pD6e9iZd0XXey3vkrhw9RNVzhdzmqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754059840; a=rsa-sha256;
	cv=none;
	b=FzTKPwmTdi3JAAYa9zE0wvZmgREqm/op/dqtKfZTHRr9bWF3ZqQSzCyD/VyR7g4t5GL5wY
	scFnuMAmkD9PXgQIo2zYqGviCt51rmbC3HTsAaOS5rK4ObF4Z9Q1VyPSrUMCPcdkN8n7AA
	VHNDOvcQqDvUic0qMKmAH4DhIp7eErw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A3fHat3t;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e8fe618dc71so453463276.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 07:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754059840; x=1754664640; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjg07z5yf4Lf1nLCjxfxMn6+NFk9uurEps7NM4R0GOc=;
        b=A3fHat3t+X53zywSUD4PbFPP3+EMzygs/U0Bw195IHVVb/PJK4lowy1KkNAPeU2LKJ
         1cCfVF5BYMX7WCw3x+dTR/rAFxFMsDRvP0ZxEtote/eatCEv0cl5FKKz95CGKFU84vvO
         +JyvY7mMfMH3oITjrdycy6hiViMqH+ICePTAC6/jzR0T3+YksyiwjwV9fdGuOO+HEet4
         e9UJ7KGN8Sb3cUHozZbvxB0jfgNi/TGyPJ8NY2YIYSmJWHZuAsb5ZJc3ApL1ZACiOjrS
         OFBJJAbTrUuQ9+rqYkodtLno4oReXBnemn9L1KW/yQETgefvDBZU5cJWJtwRqzhU5sXn
         RUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754059840; x=1754664640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjg07z5yf4Lf1nLCjxfxMn6+NFk9uurEps7NM4R0GOc=;
        b=GWAaJswXbb6ZgOr83mB+K9ZHUIIP8cSPOI6wgLb5GvuHlepSiV+Mov9OgfLFo8F1qo
         tANyqvwJZDUR07DIQIjn+sNOUhJqOcSy5HyAm8ducV2CC+ELCI++U5vw0kdogpbqntgR
         54bvhzkfPKq8rHIEaUgied+WLV/sbxRwTQIAIT/nAPQDdVAQ4YIN67uc84FPcZQP5i2J
         lg5ev2Ka/3ygn617U1E1wK5SDg1xVIgL+kldO4vU+f1XChVZ4Rlyo8/SrAKYR67sCEKT
         DByMWSvcVOKw24x0Uv/VQQNcszk4ZkeGDa7KlZmAxaKEg09W+cko/4zBRpOXY4G7oDwb
         Vr4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWiHKmuDodeyKETZ925ED9ac9rdOXKOkpePKEp/U9/MFyKmPj5JO4e6ArH24pkJz2du+GDjLxcoYw==@kvack.org
X-Gm-Message-State: AOJu0Yx/TDXfMzH8KpT1A4vY/RN0k9RbgH+2unk0YTE03QNyas43rH7h
	deoXNAx5mZGBnZ3QqbTZfdMD4A/hZVD0764j5NiClwyMMS+yxvKqAtQm
X-Gm-Gg: ASbGnctTfu5/nrNfqxmhlbw9MuoKUfRSZ6B3Yyson/AwyPgcW4m5diz0AlNYGhcm7UN
	27I8X+OiqM9hSewAQ7E1sGBrIhpz+oPgQFUzTKFM+FlUluEC4X+LyEIDV1wE0dgU57wGAnY87ZN
	AEgJZ+RfHEwV6IiiCWhh/EFNI/k77sisq9vyiuIYDsH/GjE22MBQbu2+U5NOwUxvEh+gv0XENaH
	MdNu4kxQAlGYovLlH7Z0Q+l0AUDWf/idcRh4q90UZ1CIP/eWPngWrliFMcGu8vHZUkYy7MPBW/5
	+fQP6g42MGc4L/MWkmwir3Lh7UsVcsYSFRRPA7Sm95+IkD5rjuWwf5ADk6LTXmUJeZlGDoSO9S6
	5UZ7fm8fWlBwopWLvwRRNfA==
X-Google-Smtp-Source: AGHT+IH4tV3VnN1zoMGZDId5fHOF0lyF9qZcr1Qx7AyM+nVUAAwrra+7YHKAW3JU1kk6B+TJVQjCFg==
X-Received: by 2002:a05:6902:1147:b0:e8f:ea53:b692 with SMTP id 3f1490d57ef6-e8fea53d9b8mr1443000276.3.1754059839336;
        Fri, 01 Aug 2025 07:50:39 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:58::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8fd38c0bafsm1514733276.44.2025.08.01.07.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 07:50:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
Date: Fri,  1 Aug 2025 07:50:30 -0700
Message-ID: <20250801145037.2078591-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3939866f-e57e-4caa-919a-558bf6866b82@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 921D8140005
X-Stat-Signature: kj76uktqzbzfd85uj6myzgts1qseqnuu
X-Rspam-User: 
X-HE-Tag: 1754059840-694119
X-HE-Meta: U2FsdGVkX1/Iiv4Ad6CQrzwLGudlRaMYciFTPuli4bB8jVSMkfY+Ea+zE+QWFTDH0cAXez+65jjQYFjnhfthh5jj94n+I7Qu/QAr0Qt9HQCRKTkY7f6+D2qd9/244tS7ziY4TXOR8tNhyHqwj2J0XDXndlfeVgWXcQFpYwCafEYnf24MxK1t1Gp5fM8lJBLtjVaX2vNKEZV5A59fNvmu1NbA/TkJHMP7Ta2v/Q/qbvRpt31sqaiGxZozuv71ka2fX8C1AddIU/hk+UV/Nqz5lmy7wUzIBS+3p2F7BsVUclmWT0Tkl7AO+ctmcIEwro064kzTs5RJhEfofIKnvYIa1biETqju7WOqWrYKdBJqSzxzz20+235jo7OnNBFFmYPEbvkdtVwhUe+tJD2ci8OfDvz821MoT8a40InINq86GHo2Xd7herE5Ifnq1yBF6/vvuS/x8dlEBTImc1+spBzVvw0kOSd02SE0ywmTRbcD+OC05hmRIpKfTZS/tDyaCfyuZzvUxz6ZA4Xl0jEpmK12VRryd2U5C6OvaiSqdRB9eUiknXr45Rl90AoKwd5b8VU4uJ/x2MEZTEY2h4EMgYXGeBmC9MuAq0ER1S+O3rtsBwn9SeLmID9g0lvsX92hnaX090/EnXsOtdmGyaWqretybtOy1mbdxgcPglu2MQ67myqU1QV+2/hjVVYk74An9AQXy5UrNnnq4tMHR3kK7MjBhHbC6ulSI+eU8urqNk+Q/k0196XBoIjFsQu6ZGsgMSVWY6gd4XuiYVNd1MjjCFgau1q/djBy1rbIxNUMyyRAUqt/jDz/d5CD9HRtmm2iqCEd32bQLYEktZo5YSlF04KbFIUwJSzvVAsqhCF8t2zv0BbLnDQt/Up+NqKYR05JkdCFxrGnEdwtoX1iZlmEEbHsFPmPIe4MMpSZL4+kxHUTyHaI/vWauv5miraUGgTGqOzaY3ueHR6Ud4ROK+J9qmP
 tRgFoL/f
 cnsYsMFLloXmXV3n0/TSe8FIS+DCY0kYIvQZkElkFTnNkgKpdqhWJRadWTUOPQelZwMlRAyL2C0uV5mF22WIyH1/pKU9GKjDdluAVcZ1qtDiXoOdO9J2sZLKEaLSkQKvNohmU/S7t6VIs3twvhHEmE6CEEqUBR1bhj/IzN7+JPUdfdxr0uKxV5pjRQ9Mi7gQBtN4YwVxXTbyHII2ejvJHHKz0WV+YIgT5hF7hY+bGGDLX8qKnTlZ0qi1HTrDY3Yu0taT/xn8e3bZjvweF6KLlw8dONzwEQzllVDz7JrEzw5wNHwxwTcQIG8vh5EnYmem/mqS8V6j3CCSK+01W5uBD5tBONEYTzPA0KtAtGOK/7B8eN/J/47CgjDtodexQ9dRbHDy2HYeyAwy/sNYmKZ45W5RCvOXQfu0GNOwR8wer1/URCcSRfKJC3GZFSskr9cooVjKU7rkuilsBGH5xMFkB0Bkl9aSKZS3byyP+WMuMQuT78UOWl0kjM0Y2wVOjYuNguu/DEyrq9+ChJnIDWCpQo/0HdSv5UkVKsR1ksFLrHsyAq9V927TU3aUhq2fGxdZzVppnCYq+ha9anjg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 1 Aug 2025 11:04:00 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 01.08.25 00:41, SeongJae Park wrote:
> > On Thu, 31 Jul 2025 14:07:37 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > 
> >> The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
> >> memory. Contrary to its user-facing name, it is internally referred to as
> >> "node_reclaim_mode".
> >>
> >> This can be confusing. But because we cannot change the name of the API since
> >> it has been in place since at least 2.6, let's try to be more explicit about
> >> what the behavior of this API is.
> >>
> >> Change the description to clarify what zone reclaim entails, and be explicit
> >> about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
> >> past already [1] [2].
> >>
> >> [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
> >> [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
> >>
> >> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >> ---
> >>   include/uapi/linux/mempolicy.h | 8 +++++++-
> >>   1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> >> index 1f9bb10d1a47..6c9c9385ff89 100644
> >> --- a/include/uapi/linux/mempolicy.h
> >> +++ b/include/uapi/linux/mempolicy.h
> >> @@ -66,10 +66,16 @@ enum {
> >>   #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
> >>   
> >>   /*
> >> + * Enabling zone reclaim means the page allocator will attempt to fulfill
> >> + * the allocation request on the current node by triggering reclaim and
> >> + * trying to shrink the current node.
> >> + * Fallback allocations on the next candidates in the zonelist are considered
> >> + * zone when reclaim fails to free up enough memory in the current node/zone.
> > 
> > s/zone when reclaim fails/when reclaim fails/ ?
> 
> Agreed, that confused me as well.

Hi David, hi SJ!

Thank you both for catching this, I definitely missed this before sending the
patch out. Will fix in the next version!

> Acked-by: David Hildenbrand <david@redhat.com>

And thank you for your Ack : -) Have a great day!
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

