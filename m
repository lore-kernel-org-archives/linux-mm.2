Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59AC4D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1AFE6B0062; Mon,  1 Dec 2025 16:50:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD06B6B0088; Mon,  1 Dec 2025 16:50:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9B96B00AD; Mon,  1 Dec 2025 16:50:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 85FD46B0062
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:50:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39150131F32
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:50:26 +0000 (UTC)
X-FDA: 84172246452.28.44271E4
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7FECF120016
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:50:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dLe0pYFe;
	spf=pass (imf29.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764625824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2gUPjgy4QIw2gnMHv+tif1esrjSyW7hWgpM3/SSnsU=;
	b=U8bw/wjVSoGTuBb7AfZpiQUPWUww7wso4UAR7sR/IOSJSbceh5o11gvW5bjWIpbeHN94jU
	i7jsIdk9oH5dX/KHXpcfQU+0OhEmQt4JKpPPpiPMXfjKpuGkQVUgGRoJ8XqT/B6MI3mDHX
	f4j8PEg91KyIKnzQkNQXar1M1eNhJCE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dLe0pYFe;
	spf=pass (imf29.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764625824; a=rsa-sha256;
	cv=none;
	b=1tH/UOVVk4M37wg7fSv0YPB7+byYz1o0sbtxdYnAPehXn1FolGHPvEvVZuckHNKAluCbJP
	s/lAs1uxgccYfFhsl+g0WEB9PJdTU1NwDefG5bpsFqVzYpsgHhoJ9a3T54LF0GLqWYsHPV
	A6LbL2ui4b4aubUa7K+uqaUa0EuYdG4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-297e13bf404so841635ad.0
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 13:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764625823; x=1765230623; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q2gUPjgy4QIw2gnMHv+tif1esrjSyW7hWgpM3/SSnsU=;
        b=dLe0pYFeWUmuaZjeBHoNTPLX66GCrJKdtYzUG6uWqO0VJs9HsfhuxR4ba+sW0G10JX
         uXRPYNoCvKctn8I6vigicd7xTvj61sWR+J/JMI5A1Awa9k/RTaDoUMJOLS2AIL90zH3k
         cYaQ0im4Y1T6JLfpyiRJDZ8IHNOehaBf12e/AJghi9ll+5N/JK7D3XgoBWzffz1lyncj
         GsL5Mm0gQiQMV3h2s8K8n50gP8/9V/XnMpx/ft8RDTY8GrtVfUDQ0YE+gotPMjt+jAT+
         R0X5Fnj8LKdPbYbMJ2MxkLZgGMU4b9ntIPv4qJCQivf66sS3d8rIlsb7fkRDf5diSAUt
         KSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764625823; x=1765230623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q2gUPjgy4QIw2gnMHv+tif1esrjSyW7hWgpM3/SSnsU=;
        b=at9tyPxg++Byyh/gk87Xtems5Fp0yzYdzvV0M/3sRkx1XTSRU1Iyp6bGgn6LYnQSP4
         UQ9t/1LwK0x3TCfDLwvas3p30RD0gc9V6H4nwSiYFjUvvDiMAebujM5ZDqN58F/Os3KO
         FJ83xIqtXIFLsfJl/XTbXRiCEsC9S6fUo0/NprGosYv+ilwirNuOVwBbMsiqsjc8XY9C
         Q9Nw8FOhAplBj3AkYbluzaLc5YASG8GcYvadRLYGePj/JES6MdI3ZMB6sLpWW5CePAgA
         Sw0f337iHFPzphZDCYL34k8DCUDK86t6VF9kDh/xueFSRrRPCsbuCgd5IbbgynGKWoq/
         berA==
X-Forwarded-Encrypted: i=1; AJvYcCVBu2C0H6oot3FtS+/vXzdYSGLWWfF4+sk5jvw7tW99c9Bm8hlsB4PvKktFNdPulWDQMIVFSp/EFQ==@kvack.org
X-Gm-Message-State: AOJu0YxCS+7h5rb0qBcociSI0rEzevYY5Kz3LoX5LBQIEaJS0SNjLFfd
	pBKS5Xq2rtKHicxJhzZYms2tSici9ggg1pWA20Mg3XCYFvWQnEHKXJS/0OmH+i/Drooibqhd68R
	FyN27hw8K+IJ/3hoqFsqXgJNLTDaSQxi/7vXldVhj
X-Gm-Gg: ASbGncvqUWKvv/Ad5WdZXHOYnqiPwBvM8422K/iHR0MqfzDRBceilZQVtye9ctkcipP
	fOB2K9l1d1xRlFPcQ/nmDNLZr7+EONo6MD9ScWo8C3GTY76gJkY5Z3118QkVMeaa0oqBi387vdD
	8pYy46ShOocw/33iKvNEkWHB5nmdZBKMehPac3r/rFPg4H5GvubdDSBwOpY0VWTNE5uSG41dy0K
	lq+D7jku0iyMY59nDLV25jvjmqZujeo7X1VToe2jx+ThQCFUlk+5heflhWiccBBSDDwLmsn55U1
	lGE09kCdZM+6xi0qQQwHY1CGRc5Eitc3sqL6
X-Google-Smtp-Source: AGHT+IFZrEBPEwSxzhOmS8uuG96bGPRRU+0NJa8p5/NRXXSDZscDNgunlTkO6XNKQNHp0JAq8PbHUoSf8DvZ+St2LU4=
X-Received: by 2002:a05:7022:248e:b0:11a:b4dc:7773 with SMTP id
 a92af1059eb24-11de93cd604mr5101c88.12.1764625822731; Mon, 01 Dec 2025
 13:50:22 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <cdcedd284f5706c557bb6f53858b8c2ac2815ecb.1761658311.git.zhengqi.arch@bytedance.com>
 <aScFNZjGficdjnvD@hyeyoo> <d94fe146-5cc6-4aa2-bd7f-8ca2a12e5457@linux.dev>
In-Reply-To: <d94fe146-5cc6-4aa2-bd7f-8ca2a12e5457@linux.dev>
From: Yuanchu Xie <yuanchu@google.com>
Date: Mon, 1 Dec 2025 15:50:05 -0600
X-Gm-Features: AWmQ_bmucHH7PjZPrG-zr0XHjjK8BpYhPNCrv2p7J9Sx_HpipEbnRaKoMz7jOFg
Message-ID: <CAJj2-QHu3u1RQpkBw8uV9P+-xop+bJvxt+s-ZB_cj=u6ia+tbg@mail.gmail.com>
Subject: Re: [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, weixugc@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zesei9j8apr3bn98ycb1n3mpf8cdemg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FECF120016
X-Rspamd-Server: rspam09
X-HE-Tag: 1764625824-785572
X-HE-Meta: U2FsdGVkX1817HV8Wy4C2urHmKRvBpuUDfJb3lykvO5jXhUwVawHjTMRmbEZTYf0ytCh2ymRYV/C23Fwvd9pQ2XVigI1UxCUU6lOb2hNIJxH74wDt5fJaXtxe9KPMxRS6sMEGDgBHjLs0sFFcrV32o9iQfAeZZvLCaQOqAPZlMqi5DEMqwl8PxU7quc2YChnE8k2pqzmGvM81DgRMgTkBIvQUUJYsXFhU334DDvHggMU1xllJd0zsy7FTrJBqfobxk+nCUhqLVWG0GgbeT7qWpkaY6nCZFFG1PMv6oxO43qbxQFfBTHBnk99gKFFcXLVMJEGiR+5VRFHG1L8oyku+SRj5vqbJ6T1BGI+wTBpzDnd7HIMpOsyVyUe3Zb4pJrWdLh+/raj9ceYGPzpBTer5akjmkCgVxgeEFTqLooyzc1eXqtxDXs936ry5D0OnJ+D353E7RamaXaZh3yft1tFJOc+YyW9sK0UCyBvBuzYWFy+5Mp9ymYTPtWAcn3gIAFOSj2cQGkb6IW/eBcY1lQc7HthMFR8JcYFg95DAi+fpoLvc/p/8LioABQuVM63o7VXSJoxtfyDFkyzYKIXAEE/CrDdlz8y4/YSOlHf7tiEq7FKTzPTPh+jUkXsGOxyWvThQCMb7Dm8kKe9yRaBxHuUupqrAyz2+XIAeRtEZ742SkSrVy/GOOOUXPuCuLzy4In3Rnj7krYDOjl9Gdy/XVwsB6UCpMvxWqedIob7F2kyDUc8csuDsje/8ZlzZtXbPdPEbx9sXx3Brfc6/Z6xaSnlU51NjNCQ3DO1VfXvcV9aopVpcQM7mhZmxuEmPx+x4M+vXaDyLkAbSUZu5/YhH1yGkqEUGQH8RNSKpLG9Sw1H677XAxU56iaEtBdrMC6XP6Xk5/Dvrg7rXConsuPCUsGl4DZSalIZW2JK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 9:41=E2=80=AFAM Qi Zheng <qi.zheng@linux.dev> wrote:
> > Warning 1) Here we increment max_seq but we skip updating mm_state->seq=
.
> > (try_to_inc_max_seq() iterates the mm list and update mm_state->seq aft=
er
> > an iteration, but since we directly call inc_max_seq(), we don't update=
 it)
> >
> > When mm_state->seq is more than one generation behind walk->seq, a warn=
ing is
> > triggered in iterate_mm_list():
> >
> >          VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->max_seq);
>
> The mm_state->seq is just to record the completion of a full traversal
> of mm_list. If we simply delete this warning, it may cause this judgment
> in iterate_mm_list to become invalid:
>
>          if (walk->seq <=3D mm_state->seq)
>                 goto done;
>
> So it seems we can manually increase mm_state->seq during reparenting to
> avoid this warning.
Agreed, don't get rid of the warning as this check is supposed to make
stale walkers exit early.

>
> However, we cannot directly call iterate_mm_list_nowalk() because we do
> not want to reset mm_state->head and mm_state->tail to NULL. Otherwise,
> we wouldn't be able to continue iterating over the mm_list.
>

From the original posting:
> Of course, the same generation has different meanings in the parent and
> child memcg, this will cause confusion in the hot and cold information of
> folios. But other than that, this method is simple enough, the lru size
> is correct, and there is no need to consider some concurrency issues (suc=
h
> as lru_gen_del_folio()).
One way to solve this is to map generations based on
lrugen->timestamp, but of course this runs into the reading
folio->flags issue you described. I think the current method is a good
compromise, but the splicing of generations doesn't much make semantic
sense. It would be good to leave a comment somewhere in
__lru_gen_reparent_memcg to note this weirdness.

