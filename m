Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B4ECFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 05:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6B06B00A5; Sun, 23 Nov 2025 00:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386016B00A7; Sun, 23 Nov 2025 00:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E206B00AA; Sun, 23 Nov 2025 00:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 107336B00A5
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 00:20:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB9A2160ABB
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:20:03 +0000 (UTC)
X-FDA: 84140720286.11.ED0DCC0
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id D9BE4C000A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:20:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hY2xUdgd;
	spf=pass (imf28.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763875201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDsSL1Zlb9jxmd/NT8Y1nKlEBZtEEJl+kOBs1aZkkkc=;
	b=duR6iHSgmd8Fw4Z3usT3MHMx5Hu0t2ws4lZ8IYuTYV7OX60L+BfIb7/j0uKnsEzVGrBDoI
	YVn5oCzK8siHgkzX7rF3UoS3QF3XK3y+SdbhPH+y/5nWRMLsfvquN1qKvVue1hW9yvO/fP
	iyr6Vtmok839VGLeMfMfpoBY9cYS3jQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763875201; a=rsa-sha256;
	cv=none;
	b=v6x9qewXjmcn+dEnQxxXmpeF59KigAg55XKJC+BWJ8p778uhO1ON88iwhQWfLap0qKOkZ2
	dWfGaDCSKblCd/MBMlPWHqvENeILLf7S75QMAxZq4BfOHi1TN2nA52NQi2Da4xqFgbUvPh
	DsT5VofFoRPphS59n/HbKQ+Wrl6/+/I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hY2xUdgd;
	spf=pass (imf28.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-787e7aa1631so49515317b3.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763875201; x=1764480001; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jDsSL1Zlb9jxmd/NT8Y1nKlEBZtEEJl+kOBs1aZkkkc=;
        b=hY2xUdgd8GA/PESmfplQuWhsRUIbQmRAMmGE/Df/f4MkHURZdbiJQDznLxXf52LuRp
         xZPdA4N6HlyPko3IFw4OYcBxSziNGn6Ih+OhcXeW9XlgbhtCfiv66nXrWKwJV9K6aknc
         ZVfPJu43EO6oZYBaxL9+nMsoZhSuBg8dcjghBuo4/Btt5TEqzRuThUKPiMymJ60oPCWm
         +o+mOjsyqndUOmvFJQWfQsB0pqpHnjLJzfJ6mEa8RVboozMEChV1ehrHqSpJtJBDc4pv
         KboyBUaO4QcTvsdUxR3sU2/ndQ9AX2EMAxdH0sVNXyXDVceQLe1EGv/K1LZgSCT2C3EL
         LEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763875201; x=1764480001;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jDsSL1Zlb9jxmd/NT8Y1nKlEBZtEEJl+kOBs1aZkkkc=;
        b=cfddbzWQP7p4jrH9ayp9uG+3IZnxW52e45qz9cN/3Wfbm32XemGkpyaS5LmiV1sRxX
         izOneKMqfWRGVoQ0tJ/p4gEZgA9bcKlttlFqHvDTQA+9jtXh3kFxa0mMC6m5sU9xPaHJ
         5ywHFQDDUughkTUCTQGJs0jJP1VPOlP52J8WeccAFSpiz8Pv3gfQ3YyOao6ahPXt8J3S
         jMz8D9+k1oXxzW3fbainAa4OWdjxHzMR58RdoPuiaRebHAyyEE2anewfRxkqYlZzmqwD
         pzhqLnDxpcUE/5ZshJgBq65F+eIfH1Bqi3TO8VRsYcDkZw0fEPtH9QzjMtOv97gDRmc+
         EEcg==
X-Forwarded-Encrypted: i=1; AJvYcCVbF1/IBZSsJA4tFIxnOB14FP3QOHpB4Uj1hsU5hbVA8NcRY8a8rnxYjJOu0sBEwzaRi29sBe5Ccw==@kvack.org
X-Gm-Message-State: AOJu0Yz9zh3mgFWF3mFGXzX9Rl4C4zszvpxBl3tctTW1EhEsVGuGUsdl
	WjRbmhtV+uLST4pOOlLiWEGZ5PcPQdU3eGi1QCabIY2Atc844CdK5Sx9iKRAOpRy9g==
X-Gm-Gg: ASbGnctB+xyS/7jC9jGnHHCNO9qCHPlewKi9O0P5cq9s+n9x17SFl8CW8g3jOzdsplQ
	gHNzpof7KsmWzEdDC/xEPSV9iM0jBOTC2Yt7cjkP280HfWLdeoWDZlPpWA1O8TojaHZo4U4Zeoa
	OqgGC4VGhnYZ/iUR62jZ0nEaHtsON3zDqZj07TDgmM5MIs0L77fIK+ixZmiDCBE3MZwTrTTEB8K
	YtOv+DGl+FuDmB3G7Qq+5jyvBdVCavS8r7lmcqGhhpkl67aJ7m8Yi/fWbeFajKgi0hhptAYPhl2
	B8ZRRajpbnAzuz1mNYf9svH09dyk0FznlBXWeJxfccoQLFBtXfjGRuaQqv+NN0BWAm3W3pdruUc
	8p42spKzD2HDbe74tMM4r1hmDm0j29ZcScgWlE+qsBLwPdNh77I/9vEWaUHnobpJu+QB5Dp360C
	1lQx33vPGhbmuBg5lLVitQp2TN6s75VZ/c5igwr4FLZ77aO4OyL/9/eDj0Uc1qyc3wpKkdUzOOt
	+faaI0T9Q==
X-Google-Smtp-Source: AGHT+IF0vxc7fueQhP/zzHhG7TPxCfv+GZcM3X/oy0Bl6V7n+93lZi/orIHTptl6ePqE2hjsn/kFZw==
X-Received: by 2002:a05:690e:1404:b0:63f:a2e4:a3e7 with SMTP id 956f58d0204a3-643026316d1mr5289527d50.34.1763875200654;
        Sat, 22 Nov 2025 21:20:00 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a7987fb02sm31856247b3.5.2025.11.22.21.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 21:19:59 -0800 (PST)
Date: Sat, 22 Nov 2025 21:19:48 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Deepanshu Kartikey <kartikey406@gmail.com>, baolin.wang@linux.alibaba.com, 
    david@redhat.com, muchun.song@linux.dev, osalvador@suse.de, 
    kraxel@redhat.com, airlied@redhat.com, jgg@ziepe.ca, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, vivek.kasireddy@intel.com, 
    syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com, 
    stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/memfd: fix information leak in hugetlb folios
In-Reply-To: <a4319c8a-4e81-00de-f184-844348d85681@google.com>
Message-ID: <250c36cf-6334-4b82-dbd1-5618a24271da@google.com>
References: <20251112145034.2320452-1-kartikey406@gmail.com> <a4319c8a-4e81-00de-f184-844348d85681@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D9BE4C000A
X-Stat-Signature: wbff66bktex8aohbtxwtgi9zqcry1anr
X-Rspam-User: 
X-HE-Tag: 1763875201-602378
X-HE-Meta: U2FsdGVkX1+wb+lS58uZOnn9VjO2ObZ3En9UGe63o6HEkAjxYz0PV7oNGbcKyioS6Cdc31LqKqg9V/dmsrbAkpe+IQACBCHjlPQxIldwy2E3jWU2oF8VKbe56Oo5zKTOWzrMlshb1G/+G1fY/fLh7umB7xsu+Mok1eC62aA2hk+XM3Y/ZcpuEFvDi0RSPCae/nvv/aY3/WoYFHoEoN0YlI1+PvrCC240rhUGgXsqh0UcOZxNK0B2uhEppmFtAeefgkNiN+B4hFaD8xFiIii0vCXYPGhF7PZbt8fnIuV8Qg37sH+6SnhQe3RlbVSltx2kly3YsM0yAOQ2ORuQQ/L58skmGi+VYjUvZKCi1R3/tsID32OHBmRwHFzArr/FmNXHYIZJSTv6mO8UHYrYGY5+xb1ASlLZvq52LJX453Zs3Th0EjHL0SywTL/wfQBpCqlJL1nlBe6VwwE7qFo0TlbtNolt6UYW+AchP0bnJlAfhgInoJ9gEpHthbSkqpyKM75iqqwDSaBy1K0IAUs8gaZmUbldRIJEe6VbqBhGnN2hANcDAhvuKFGLuYHkvsF2e4Xo3jDyucno7SmdO++AEhQlHdko2eOTgIUfNtWByHBjizWg51F+//8NCZJFNmBPh9cKrFaLyuAUEYN9cFslz1E1eBKkyylBqkm8Fn288SEX2Yk9UaGo4Bhq4nSXIL8oAXJI0SAtJOVOR37QbskGgq/2D/23LWuBXM3dQfJEUu9YnR2a32Ix6YjXS1Mo3IU+mnLwv2dFieezIuu2Do0WJ7K12+nJOtlrmahic1nBPq//Nzwdhlo7iTTReHRv1BJvISJWbZ71Gly2uvjIf0cY6k4rKf8e29/Oyo2WwdAIbZc+0fQnt6gsiTDyKNAXuRGqtC+j5R0UThSP+VlhlU1j9lHLgmOSK5BbGtHip8DDfRg1pdEi+ZZyLpTobqOvax26L5kV5hu6cPaLwum426W8loh
 GyPCUC52
 cFshc1LvhZtft3nUWnABVtH6Nt9VdVOXrnj78l7InKqCXkXxqiWhHjSrSQPKIXT1NZKMbITRrf3gwWMqEy7YePBf6y+VsIlpc9Tnh0OZWpvvXAykjAamJuSXGXoUt6HIwvowK3xxWFA0Ij4ku+pjRJng27QH7OsuvadZ1wdd4F0UeY80iEI+hw/5P/YUM33k/RnhUF/7V8o5kM076W87eaZ6jRjeOUMA88K/wpD/jlIx2IQ3IUbs4Wkv1xsOnJRDxWCKCgE+iS/07lH5zDzcaKc/iWUx/A0tZRJgu67NFGgti6HuKJo1CMFSSrORnagP1Mf5lNFwOAnSzt36dxZY1T5l75PCPTkFKywk81STIX0X5jdtOLJs/eSGk4EUCHZ+voXu7jaZqDlY+8SN+b/fTYLnvTlxvbj6ux2BXSqSnhgSqutq99b62QiiLVUyiKSS0vpkm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 22 Nov 2025, Hugh Dickins wrote:
> 
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> Sorry if you were all waiting on a Ack from me.  We're agreed that
> the comment above __folio_mark_uptodate() could be deleted, and that
> it would be much better if this code can be moved to a shared home
> in hugetlb later on; but for now it's more urgent to get this patch
> into hotfixes and on to Linus - please Andrew.

Ah, it is already there in mm-hotfixes-unstable, thanks;
sorry, I somehow just never saw the usual mm-commits mail.

Hugh

