Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D13DD39418
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DA66B0089; Thu,  2 Apr 2026 08:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934C36B008A; Thu,  2 Apr 2026 08:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A556B0093; Thu,  2 Apr 2026 08:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 724246B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:52:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 167A9BA312
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:52:23 +0000 (UTC)
X-FDA: 84613604166.12.6BC7EB5
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 45D401A0007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:52:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h401BGmP;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775134341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=TQ3lrWVKO87z8vhsStJXZkDwRc6VLmdZN5o7clgXULk=;
	b=kD0d2aOlJX0kfgliQdp+xPS4cEsqShpMFOoSy0jszUgTTgsqC6MwwyfqPLDQINIBbVK1DG
	fkXsNWIaqQHwLIcX0zZcpI6QkQy9eFl2JT9wirrCNtstczWkee6+V4G1rE/9LV41WvcFC4
	shRG10s8ySZ/XwMpLH4YO99/cq6Wh7I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775134341; a=rsa-sha256;
	cv=none;
	b=RMHGVrNAnQ98kIIWYMUwFSX1uydmjkp6fDeSaeHp2Rxjaf2uw/jOz57HR9l1ChburnmW+5
	vIIggPCJvhQsgB/9+BUp95YNko5velZiuW3IoopLz67tdPa2h1OQzJZqDkTag+EN4AJgHP
	2KsIclEWsXYFAUWjCaAwxR3Hq98FoLQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h401BGmP;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35da01fc0baso524494a91.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 05:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775134339; x=1775739139; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TQ3lrWVKO87z8vhsStJXZkDwRc6VLmdZN5o7clgXULk=;
        b=h401BGmP9mTcfI7zJJQTTKiJbYG3uJjMfjRLikk0VJjk0ggyHf26QgDJ3+9eKLCPqL
         ON1A5zt+1R8ZmPadjjWC/jgdtwZGQJCUxBoBlHH1iel3kDQjCoIb9agHD3b9PWK3JS1d
         pPS6+TxDX+ln5XAJgFxEmArP+Viih6EiCA5j/fYNTmOYGlxYweHa351v8Pki5SmHZdar
         RbQQKutwMB8QSXpwSB8eG9an1TVRFE+XjWteWouL2OkjOye3L3JsrPWg48xe5JL/EnFv
         Mxkc15NZtEe7ZKdAIP5I6oRqQqwkcyMggNhO77mMYgeEoE/AHt6z6guVBe6aA13WPeXD
         vxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775134339; x=1775739139;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TQ3lrWVKO87z8vhsStJXZkDwRc6VLmdZN5o7clgXULk=;
        b=pwere2zqKeHp6YM67Mpi1Jc5V73UHinPeiWOEjgZq9AUAw/jkeuwaKX8hpOQIkoSHd
         KF8F9/i4EBTH4x54Xs5cQxbQFbXO9vCG1kf/oMWp/oHNW/To4JCf6rwHn7nhUnQL70rT
         MiudBSVTyGFJTeyP/p4VQahxg0qJcwRR/c0udeEb9lBQfNdbCStOwaLOmyyfCtACX1Ew
         pZR8PXAaY2Fqves3E3PIVLf/X4QQRMruUOpuH50Fyw8qBjYNGDOTfnWvPyOBQZ6KWjdG
         wweJQEuApdaH/y8ErNzuFhGCvxAstVm5bDQ55j+XHj/OgDQfEUYeycycycoyICL3G04s
         +M+A==
X-Forwarded-Encrypted: i=1; AJvYcCVcCNeq5mHBR32ZiQhhG9+qtJvgR9e8Iak9EdVmISdAUPvj8GE9Tuc6qnGN1GksR9s3cuURn7ZDlQ==@kvack.org
X-Gm-Message-State: AOJu0YzQlHbZz1sdLv7Jh+vwjC7swfIbGcQc4axKO5JKJ6QxqnR/lOm1
	SA7XUFySBBxL330epUEa2utokW0CR2n/KPu8key7dJJZf7rmv3+oBsGJ+gcvGcEP
X-Gm-Gg: AeBDieuOPrJhmMlbhtmT9Z2ji6t+lS9Tdz+3Ll9J37Q0sV7Rotz0QTP39//fg0D6Ad8
	6YXLvj4J82sW4gIzKOSdwdp6y9YhEHPparp6PckjA4+Bb1+dYOZFgZP9SMU+FqUVeaN4nsGqD/M
	Sy+MDq/UmBeRumpppWSN7BS86M0GfRy9+XkKGPmhDGyf6OeElMir/MG1u6yg7rX3Z5DL1z/3wPS
	W1mlCq2HHtPD6N1ToLHnIPE7ATi2Ga1mcsGBsxyfRTAOAvKpuA2qq09BdB93YrHGzy8VtYJv5wx
	O7bTJvMt17VlDYyt6Pz758sFOGLe5F/e52A/S2Wx46+eW6CZvylZdfk8g0nnQOKLOh8mjjctmDr
	NfhDRsQGfvaiJZEbzb6lnW30KGsoL4qUXuDPDxOv/43GjhfjGzLzt37Gm317sn/X+G8UZJS/YMS
	SEeEKh3eDqQQjOuzbeQ3kMdw==
X-Received: by 2002:a17:90b:1850:b0:35d:9c39:4dc9 with SMTP id 98e67ed59e1d1-35dc6f8a3famr6709877a91.23.1775134339387;
        Thu, 02 Apr 2026 05:52:19 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbb8932ecsm3838360a91.5.2026.04.02.05.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 05:52:18 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: fix IOCB_DONTCACHE write performance with rate-limited writeback
In-Reply-To: <09672fa10c77d4fbfa1a13ea16aedf79d23fd8f8.camel@kernel.org>
Date: Thu, 02 Apr 2026 18:10:32 +0530
Message-ID: <h5ptmt6n.ritesh.list@gmail.com>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org> <20260401-dontcache-v1-1-1f5746fab47a@kernel.org> <ikaam0ox.ritesh.list@gmail.com> <09672fa10c77d4fbfa1a13ea16aedf79d23fd8f8.camel@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: p6hhsgof665hg5s76junia4e4y7m8jk1
X-Rspamd-Queue-Id: 45D401A0007
X-Rspam-User: 
X-HE-Tag: 1775134341-506261
X-HE-Meta: U2FsdGVkX1/pzUs39B0RD/lFMLF3UWjcRdWGgrgu1PCZdBiOUTPG7rFSbF+fSxACWpBxoClCDm73MqhQCwPp5z1+QZJ7HE4L6xq1VIO6y/Q8L3S62DaUIYA+A+jzRln6N80tRSAlrMp+W48n8T5tVg+HxggdEEFHFnA3KncjPCHIxnmJFMbC7jtd7U/+0TV/8yehJNxEv3xsQao8XSEkV4wG6KOpPjzzhQaglWBIA/pfQ52fH/Zpbg4R1NRw++jnCIQa+rJaImfpwg+bv4+GhXhA+Nx2JVkf+fgiGT+Et/3xB3pzInMFqPW6swnQKi+I4C3prv/p6sKaHo/Th9gEuajjN/koPpVKJW4eougCaQz2qd1qK1Wb9yja11NZPnTzooESXUTP73cnoE1kWGpI3gxhIQvHDHTU9YL6DzdYDGk6aDF3pLc9zxNuzjyt6heyFikIB8m8tpHH3Oy95r/9wOdwZVY+U996COXiujzW052YHgU7zoCR9H0pFI17184Hk7K3Y0u3CGoAsldi0i39fpbYRfsfLgAJTrglsdgHhH2VQluUWSqtttPg84s98lD4dEQfRgEwWADBaVsi1FmDpMCow9dl/oayuKSM/mqQdvw2xyFPYTjnUE+/LwvrnRu6waTRoHyAMEVlSO8rJt7V9hzvviucnQuYRZl7bGn5v28OAhw9kOl/VgyjywQwgaEEKWjQrIeF/vQ4ZBMyk3TeWXpdhgDWf9yA+Jwyt+iQnFyQAxmu1Q1u1DzL2UgnEXSbQov8NUrEzBkaOQIEEb1x0pC4ejSUJU5MXba4EUZynIul+9QrIS0fJxTQ6JWkIN3/cZ3hFE0/C3FcEMGYN7E3MMFvm/tdE/B6/pkwEldxJ83JRERytLrpod7Ok1V5kSd6jJ7w5w1QB/TW3V69Ua+Rd0X1QwlbvlLPQ3K2H9UyKOTHiQMGewN4A33R14S5M0Yhj7lDesn9sgaiebUoA4V
 luGZi89Y
 05G33BXGHNYJI0Dd3HGaCM+k73W9Ecy05EyOiDGZiGqfBBT6bOA4kMTRBTBrYeMqcVK3lYtbyEeaV0pasBNiW9MA8HVCtQpi/s/NlT6vLia9wnJwLNRft8Q/UAlV7aHxlsuSRQAc83Fj1XDd+TtTXOJ1Z96St5B2cwQRLxnKiJ58gR2dxEPTnxBrEhkqeG3TmM5YDqAMeiBOrDJW6/GCRZdHCMJI0p7QasbFIQq/4VR1rdlv8sxhvxjKhkpN0i8TexUbuYR2stZ4XGYqOCTun+X2Uf4SkLCpMQEzQL9gB7l7nmZG25oO9ElplNVf8zYjTF36xSHrf1FYQnZqNFYuyEXk2c5Mq3t4Fi20lZLlRN/g1rFfPCyV/dYPaxncrsrwdwxk1Jx4DffMFiMMxHmFgERE+Ye8lbqQxUalSr1+SPtbw10C3/io7PYakUCqLh7DwkJQg9YOWzkzAmzmDLaRKKYVP4MFxQpISLvudwZuppFOO/CQmMIivU9+PoZyNAv8Y6kE0Xbfk3doqMIl4YT4DvUwr4anehty240D2BjtjNh63eSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> On Thu, 2026-04-02 at 10:13 +0530, Ritesh Harjani wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>> 
>> > IOCB_DONTCACHE calls filemap_flush_range() with nr_to_write=LONG_MAX
>> > on every write, which flushes all dirty pages in the written range.
>> > Under concurrent writers this creates severe serialization on the
>> > writeback submission path, causing throughput to collapse to ~47% of
>> > buffered I/O with multi-second tail latency.
>> 
>> Yes, between concurrent writers, I agree with the theory.
>> 
>> 
>> > Even single-client
>> > sequential writes suffer: on a 512GB file with 256GB RAM, the
>> > aggressive flushing triggers dirty throttling that limits throughput
>> > to 575 MB/s vs 1442 MB/s with rate-limited writeback.
>> 
>> I am not sure if this 2.5x performance penalty in a "single" sequential

Sorry my bad.. I mis-understood this 2.5x delta at first.

So in a single sequential write case, what this patch is mainly
improving is from unpatched RWF_DONTCACHE (1179 MB/s) to patched
RWF_DONTCACHE (1453 MB/s) = ~23% improvement.

So the below theory which I was talking about was from this delta
perspective i.e. comparing unpatched v/s patched RWF_DONTCACHE mode.

>> writer is due to throttling logic. On giving it some thoughts, I suspect
>> if this is because, the submission side and the completion side both
>> takes the xa_lock and hence could be contending on that.
>> 
>> For e.g. since this patch skips doing the flush the second time, (note
>> that writeback is active when the same writer dirtied the page during
>> previous write), this allows the writer to do more work of writing data
>> to page cache pages, instead of waiting on the xa_lock which the
>> completion callback could be holding (folio_end_writeback() -> folio_end_dropbehind())
>> 
>> If I see Peak Dirty data from the link you shared [1] in single writer case...
>> 
>> Mode                    MB/s	p50 (ms)	p99 (ms)	p99.9 (ms)	Peak Dirty	Peak Cache
>> dontcache (unpatched)	1179	3.2	    103.3	    170.9	    14 MB	    4.7 GB
>> dontcache (patched)	1453	5.4	    43.8	    57.4	    36 GB	    45 GB
>> 
>> ... this too shows that the submission side is writing more dirty pages,
>> then the completion side able to write it... 
>> 
>> I suspect this contention (between submission and completion) could more
>> in IOCB_DONTCACHE case, since the completion side also removes the folio
>> from the page cache within the same xa_lock, which is not the same with
>> normal buffered writes.
>> 
>> Maybe a perf callgraph showing the contention would be nicer thing to add
>> here [1] ;). 
>> 
>> [1]: https://markdownpastebin.com/?id=96249deb897a401ba32acbce05312dcc
>> 
>
> That's an interesting point.
>
> The theory I've been operating on is that the flusher thread ends up
> squatting on the xa_lock for a while when memory gets tight, and that
> blocks other readers and writers. Staying ahead of the dirty limits and
> limiting the amount of flush work that each writer does alleviates
> contention for that lock and that's what improves the performance.
>

That's right for comparison between buffered write against RWF_DONTCACHE.
But what I meant in above was for the improvement from 1179 MB/s to 1453
MB/s could be accounted to less contention on xa_lock on patched version
v/s unpatched version for single write sequential testcase.

> You're right though. I'll plan to play around with perf and see if I
> can confirm the theory.
>

Yes, thanks, that will be nice to have!

-ritesh

