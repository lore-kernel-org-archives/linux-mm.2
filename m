Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C918C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 18:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2406B0088; Mon, 14 Sep 2026 14:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271326B008C; Mon, 14 Sep 2026 14:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160716B0092; Mon, 14 Sep 2026 14:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFEE76B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:36:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46F6E1A0239
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:36:21 +0000 (UTC)
X-FDA: 85213222962.07.479AE72
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3CE4EC000C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:36:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=O4jDnTRi;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789410979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLXWrepmwzfofzjtX5AuHaJ9cfFcfDLD9/VG5Rf9x6s=;
	b=bEcx63emF4yCbfRVAuDt1gCnfLYn7ePLyG+tL7O5fpEEJQ2Q3KF0z7p0HJ05noneHchWq3
	yBpN0iNoCHhdN/lW7IKF8Wu3firXaD5Yq74MeftuIoZkudydVcw1SNrY7VwmNMt94DZybH
	Zf2NliULGDmrb5ndBXWo3Hnrfdmh6ZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789410979;
	b=HrEXciFEjSBnIvW2P4aGJNw+RbPBqAxLU+0waBmE7s9Rt4aATaBLv/IDVzYYdjMqzplUPA
	NFKRNP4EHrqIPXNwOwiQteFvUGOfsqfNSpvbvuUpqGfdH0saoBZDOy3Omqfo2zhU/ZJrFU
	t9myALV8/KizI5kN/B6OqZfWgFtAlQQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=O4jDnTRi;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a99cd5115bso3872972a12.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789410978; x=1790015778; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sLXWrepmwzfofzjtX5AuHaJ9cfFcfDLD9/VG5Rf9x6s=;
        b=O4jDnTRiEkafjyPYAQGs9LBi7JHxJLYrksma6HXtUU6POOaO4NhNYn1mMAc8MgSmfU
         yqFfKHkH+2RDpp43d/7IinRRqxBs5Ctf23flwBLC3p3KMekP6T9ngpwTJ36iIGlduxro
         WyLzqfHjEwaz6AX7M22H5Jmw8ukpzzyMdSjFKVO5DrGcf5pMA/UiR0HgknvKkbJGQxk9
         R84qtZtftCqNvqb2YSaYnmLcbPQRJqHTRHqp1DRoc2vfB/1QbGEHt9QdFpN/AVwsuu0y
         FUkMJ0mcixmKYGTI/FtU8RixUaqqAHHiTE+FWNfqcUn/lAupS4BFdQaNQCvQabDhtsIg
         zK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789410978; x=1790015778;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sLXWrepmwzfofzjtX5AuHaJ9cfFcfDLD9/VG5Rf9x6s=;
        b=qBREWOZk5EC/lKRcKMFEAYjc/F7KVKzsQ4SpnatIDw2mA/Xa8jsvc1tBi+2fuHdaDh
         /EDJehr4ab/ig4zqB/jImo0S77WEhSLCRk7Gs1pGyBjuK2Djb9yQu4pV3T0bqnLOEk7v
         2O8fp1j8dNpZB19WZ6ucK1OfPYqBXlCz8IZ8Ui/Met+wpdK5LG/Kn3T0WLUn/Mf8o/lV
         F6fw2wIw0htHMPnOG9TiL9vf/05/sQ8ToFfwU2QtLuD5vZ+OZ/jy+fHS8QLbqkuyR2Fg
         MUEOgeMJ7o0CTAIzwbaOnNrP36qmzw48mVJ0+iF7MGprs6Dmqhtwpul83g5Nv8TnpUA1
         do2Q==
X-Gm-Message-State: AFuF++mRhTu0+M6i+Cf+6JN89lVkjFqapW0c+h6Erbbuv6kVm53Xrcac
	O/bXgo7YcX3WmhRc7K8InX48hiV7/9SwTFbGmbkHwDfRwZEjbQjgEYMbLqucnhGgZhQ=
X-Gm-Gg: AYBFou2LXeQJ4UXY3pqw956PxTjTCF+b5hrsZI0Jn6QSJNxHMMv/l7dGLUyJXO5QaAJ
	S87bl/iSr0ZLeyVI2mBWH332iCgxvU5aDjTymX5Sz/Lbdk2HfwoeYMqNSSRn7WPcEiUs1TWwLs4
	7oMse1wqFEcDdlLK/i6oX1Lo6xdQGvGMCuddOCiy8xyrQCWfucChZDdE7eMa0DmQEgO8u5D7vBT
	m6jfzjqKCa/gd9dPrsWePcDd3jBFQuyCg+jsf6tDnYMAr6wev7x7JUv+lVtcBCl5yRTX0sI1Fgb
	CY9vXsmx+W9Fnl+RSFhXDPrt/7IX27sChIePMgEX9VU5rFda3AKaRuBJknLnD8bhLc378NwhWOT
	pkFTc0XOgcFHSnp5mHWF5VTZK0eLcTj0v/iFW2+cGzAComEfQM2OVY4bUkn4EDGEONFZJMzTGLF
	ex2aDzrXtBpGMFMPCgVRwulLLvf0nTTA6lm+OrVUe9f6zrElhmShrOayZi5IJ0
X-Received: by 2002:a05:6402:4499:b0:6a9:cc6d:ea4b with SMTP id 4fb4d7f45d1cf-6a9f63cd8e1mr2485859a12.21.1789410977836;
        Mon, 14 Sep 2026 11:36:17 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9b594c28fsm4680607a12.23.2026.09.14.11.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 11:36:17 -0700 (PDT)
Date: Mon, 14 Sep 2026 20:36:16 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
	Zhou Yingfu <yingfu.zhou@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: fix hung tasks queued on mmap_lock behind a
 long reap
Message-ID: <aqg-oG2HDIUeK5Us@tiehlicka>
References: <20260914113239.367200-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914113239.367200-1-jiayuan.chen@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3CE4EC000C
X-Stat-Signature: ma4r9c6j4x1n183thogrqtsmwc19a6sa
X-Rspam-User: 
X-HE-Tag: 1789410979-424426
X-HE-Meta: U2FsdGVkX1+b5H6K1sGQDtm0HP0qVIHMVfBibMS2aMxw+fZ007i91JMQU/yWznj9jqfHtNlr/CR5NO/KKRpUgtU/0yM05nnTLAHRmBZTzxEefx1dNJZ4dVuoDmzHk8Ml5lZGsvM+D+aNDT6jktQMK1uT4bkjdnCqbKa2cL50W8/PJvB+0VdhPc7OuLIiJqo3GcWbiFdZlw5EqCQ6hv5N+3VrbrNHEYHMeRQodreVpH1ulzE5fZQKovxcJcgOk9us30YaZtphtwfF5L7QKym97UWl91fVEmE8SrZhLmmSfz59Na3FMx50Udc4m2zimAo7hlVXWSgfPLfEd5paCNa+hjkh0U5C0EUYSHITHFQfplDtArQ0tHMg8Y5kLwf9axxNcVm4dyMFjDWKk1p52n7rvfsJDngRLzqziKVAlqiNW3zfwQnu8BVGaylga5IJcSOvedd7vqo2cVnEUZG9ApcJcSbzzHnuEw3EdENx+jb3skbK6R0N2VL2Sm5XbiR0inAKw1iXIDvXza244Xeu0J4Q8iqBaPGyB4gsTgaCG6CKT3ey6fm4B+taiiDSX8Ti2QcB55pX7da7AmgXJQ9aY4Ush7EfCFfWMBna8L2A/RvKRSCYBm/JWbcIFPYtOkO2pNIp62tA4s5S1MMyACLNN04Dq8D9Hhn+CN2u1a70z00aDbDc4DhcbpT2nm7hDJlRyS6wVh2ZBRAjyLG7MzdU7OYU6cfu90DWUVIL0RZkei1U5Iv56Z00JymRvqpFWwxc2Srsiz0MPKl5s/dsxgs/HWJI30FuKk1m9ILfpCHUtY0t9WVr5jkIdfT0xyxhoTS+d1BsYV/NQTWBcn0a5GLHaaxHCRgAwRTUy9TrXcKvCl0xGOteWPQCBcdOBlrZUk1V8eh3pAi4voXqhEgvnNqc5VOLD4rc++wwZwj+7+1CoZrA/kUuWgs5wPIhOeDOlRzRnMo57LzekWKQREG/n+5IJD7
 ZtjHykZu
 ARmTk+PqVZR7jP8Z7f+JjiANUNG8Pb7tVVjjiRBaA7GnSM27p6/Z8AtA/f2jyJgibMNzVDb36ePWMTjdzGktrjo6ex497sWVQAzcDFRolSU2EY8Cxts2oGLMFPCmhqUmm/YsCC9GJO820giq3cfCQPTX204DrOqS1y1D+MnMotKWzd/mQslgzCHr+n7lpHvo0qEgABCNHeGd3looKxg4HdgXDjzRad7BxTzA4fKH8bXAYfP7JZp2E5s3OfcTRycf08/N/km71W0sceJKEz4De8eazSaTIExqmeoPCvvMJCr1cq1jiZwExp5gUI4NteoBWx8fynctpijc6tqnWzgrTOcPbD3A97TLBa/AkZgxRWJRJMu+xtwdQvGSap10fWWqEMVYxYSXCU6kK8C9N6HBuu89VVQbbS+mDLrQYiXBOno+exAw271+hIsZ6tchIqnBEnTFCgYHRzH6G1GaI8DQWlcZntTzxTYAL7CSLafznZPZwev0/z1T5x4jwmV2+viX5sJfI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 14-09-26 19:32:37, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> The oom reaper holds mmap_lock for read while it unmaps the whole
> victim.  Anyone who wants that lock for write in the meantime sits in D
> state until the reap is over.
>
> With swap enabled the victim can be several times the size of RAM and
> the reap runs for minutes.  LTP oom01 trips hung_task that way for the
> victim and for ksmd, on 6.6 LTS and on 7.3.0-rc1:
> 
> Call Trace:
>  <TASK>
>  __schedule+0x487/0x1870
>  schedule+0x28/0xb0
>  schedule_preempt_disabled+0x16/0x30
>  rwsem_down_write_slowpath+0x1d4/0x750
>  down_write+0x60/0x70
>  __ksm_exit+0xb4/0x230
>  __mmput+0x12c/0x150
>  mmput+0x1e/0x30
>  do_exit+0x283/0xa30
>  do_group_exit+0x34/0x90
>  get_signal+0x952/0x960
>  arch_do_signal_or_restart+0x41/0x250
>  exit_to_user_mode_loop+0xd3/0x560
>  do_syscall_64+0x385/0x470
>  </TASK>
> 
> KSM is just the one LTP happened to hit: __khugepaged_exit() has the
> same write lock cycle ahead of exit_mmap().

Why is this a practical problem we need to care about? It is kind of
natural that the oom victim exit path might race with the oom reaper. They
share the same lock that is mutualy exclusive. The whole point of the
reaper is to ensure there is a forward progress achieved. So before we
start modifying this let's talk about any practical/real life problems.
-- 
Michal Hocko
SUSE Labs

