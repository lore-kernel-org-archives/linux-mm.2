Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FA9C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 01:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE2B6B037B; Sun, 16 Aug 2026 21:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28EF26B037C; Sun, 16 Aug 2026 21:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0484C6B08D3; Sun, 16 Aug 2026 21:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B509D6B037B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 21:15:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27BC6A3078
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:15:30 +0000 (UTC)
X-FDA: 85108993620.13.670AAF1
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4BE52140003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:15:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=te190mJU;
	spf=pass (imf26.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.160.174 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786929328;
	b=J2TH6OiRkwDLCkeq5RAAHAjJu3oqkcrP7BEywytO5iHy57iR/2F+OoLHy1YY7Dx9+PyxfV
	DBWasFpMgfTFjsQEkfbk0r5nkxshNphxw+0HubEd9pgtdWtXF/4+WeofcETNX/+fooRB3u
	uj5QwZGbdiOYYfGuhPYNmlhWe4AAnW0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=te190mJU;
	spf=pass (imf26.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.160.174 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786929328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTaJ6cDDsOKdUS9+/FHpIpAVWqmJlzOEFqIUeHlYwtQ=;
	b=6CDsU5cbNTZrpkBBEWKzmA09/2g8MpP4mIccIvIyrV0/vjB+kR26blhH8FujJtKMIKb+Z7
	RAFYxPOLQEEmDlArgpVVmNrc+Uqb1HUqaKwhsbhswseHLOrBZZQq+pQhckm1InxNzU8DCx
	qvaAEe49R+RvR+jEJbr4QVTi1TzFxAg=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c04bf4711so28972501cf.2
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1786929327; x=1787534127; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uTaJ6cDDsOKdUS9+/FHpIpAVWqmJlzOEFqIUeHlYwtQ=;
        b=te190mJUXNJxSp+opBPng6EvE2Sm2mvtxxQcuiO01533BeLHNWGZU07z0UbnH0vEBZ
         zKdMGAIJd8kno7fa9WIf0Y6M0gLx8SR2fUnWfttOJgocMBQrscX2yQxOqaVzEtQIMInD
         v3mirjWDPuGFD+JlfFOOzq5tnIxMfokBMaf8A7Ot+o17zZvgLmJbacrxGw0sCn7o74s3
         QzmYF9PBlqLnESp8VAOqihvKE9dCS4ofvYs/pe7Zdpr8rtKT78kgagkkbW1HklIrwDsq
         utlSx3Bp8gLsPAyeZQuu+HSSWh/eQdtn6m+ClYKAmFTI/jAWJ7InSOT21WDs8NLZ9Ajn
         /FWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786929327; x=1787534127;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uTaJ6cDDsOKdUS9+/FHpIpAVWqmJlzOEFqIUeHlYwtQ=;
        b=UeOQNGgBTDU0Kjb5qhNXy/B384Xd6pvDhBw7B5LXaXUjy47qauWP1FKrOk5Q1kHG8m
         jtUL+rmoQ3Y4aN1/PnaFl4RWkVadlwRssN0qrx5I0x2zIijBZcYNFEuXuMZuOTPq46mh
         2BkKexHjm7dzNLG5RDIbsLa0V8Yentah+mohdRDL4u99sczOaP00TfkNWdHtHM+qsaUE
         nM9GoD6YxUdbz4bmTJayeHY3qjtbi6TIblre2YUIINxqc1wrCtr8g5KeJq7RPPNEM+c8
         92hbcaRwr8rrPy5S4L89nVRDF3mJCjNgeU65gUvXTFL5kCslLXPsfKKLWGF3Abk+CAom
         94KA==
X-Forwarded-Encrypted: i=1; AHgh+Rpzgir6xwDjI+BBUUzWxQqKuegyUfsnXIkhSf6qQKILo0JcRvBk8+3Ls1GxGiLxlkNhlsovrX3b7Q==@kvack.org
X-Gm-Message-State: AOJu0YylgpWVbSxaR+ySyJ3w9uQMtR+vk9ZttfEMKmUYyhYaHByF9N86
	d1cGHFrKkx0UQZBV+QDyWbocN8NsABcxaN7/qvWEsEN39kALZgVclO/bWT/baAKONQ==
X-Gm-Gg: AR+sD10PoYbDZBI8WoUjD9N64NTxb21vZIU7Lj4Xi5g2nG5m6AIj+gy2JtjurFuiPad
	dxvCCxXQaKJ2tMIlFfnppD6wOyYIE/7/P04HlmK2GUAh4jbMbQ+TokMDcYXYjD421cgOWppv4zO
	dFW7ZZqK8qTrtGtl2cUmmUr92J66Zg59NwwpaO6RmKF5PxOdgtEpo8WhK6lSeJva92rBQPneW7R
	IgNpzyK7/rMD9x16FOEUKvMzk1vJOBKM3LiwgVJM8sL/ytDiIKEdxocqT79KH06GpsIzt5qdQfu
	6SS5SiQ+Se5Oq91fUlUD+Oe8XneASWf2dyaDQA7WjChvJz48shQZfKwDwLGtNiZO/mjme9pHQZq
	qtDYcK0NOn+YaEeyoCHS735kXChpTRlY68kKzWoh//uKmDm9HMIuf6W8tyOcZhtN3FCWlMu5Ws5
	a+vx3jyzM53ZW7PpFn2dyLCLlCMrYgFx85Po67Xchz5OsoHSO41uIMSWfnItxjaw==
X-Received: by 2002:a05:622a:8f:b0:51c:f8f:13e with SMTP id d75a77b69052e-52d854ed352mr222577631cf.40.1786929327326;
        Sun, 16 Aug 2026 18:15:27 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::dfd8])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db623aed9sm1662031cf.23.2026.08.16.18.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 18:15:26 -0700 (PDT)
Date: Sun, 16 Aug 2026 21:15:22 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
X-Rspamd-Queue-Id: 4BE52140003
X-Rspam-User: 
X-Stat-Signature: 7sjxbkoiwfjrrb9q79uu691nzfi3ox4q
X-Rspamd-Server: rspam06
X-HE-Tag: 1786929328-395368
X-HE-Meta: U2FsdGVkX1/yX80arwoXOZMBZCPSmf9tN/rgnkowIjnxQm6NX/9DBSdntgg0WGGhCzawLb6No7uRbHFp+crOWZshm35j3X1g4BMU7KGbkBB8WGrbNofDddukqIDNFEnoCrqK9XeziYdhqdSHVWS2Q7dGsRJPORQNDSauysMt+qZpI3xHmBLU2yBo7B8+04AsZpX7IVEA1Lb4xPUyXn8xTfCA7WoK1EO1yP/PL9XmVtJBiwmK0yqP4/nxpKRaWy4UAV+BMltpwMcK3yoNpFK1GqiLx0cbpSA5w+IQihgXaIKlEr7bykiyMu3cXZm2pRvYwbEPGpkpDlTiHBkFRNtslcERwqrnpRf+TtQLFcycufXJN87C4TtWTPOxHmvHFhqAa1hbHJ61KIIhP6fksDwAAocinJU+qCS4CxYaMPAJdFmHFxhSab5uZvx+m3ESokPKeQJn9mmsIuPsDEUzybpd31j+ZPRbiXhxVTAHKV91eBCz0SwRYOVDQE/iix9VxzupDP3k4zvrYdwRLUdV622zvVJKm1w3cHmlQWGtJUFihcEkOuEb9q6tPPWc2fK8tpvSyAuCOzaTWs6z3CWrBkerUsjtaEzxaG3+WkEFQxIxPLE6AZIZNDTu2sw0QfaB6xmFbtTVwQFtsx3FqAPGX4kdB6k5oonQD48+bIBY0GK8ciL4kEDCu97Dm/YYAkVbWWjq57R1kKsyLuq9AbUTH+24PSwCWLZY3YlcEHkR1tcJXixQhIe+wG7UxyJoY0igQAtRZUlYd3JcfEjZtkXPRs7dwpzQ9oYTjSqEBGJlMwcX0HkEZaDAUHjv7UckRLYnpr7KHqu6x6QY4vsieqydKo5Oh8b3bDIbRSFqnOYiR0ACC4DOSSlo08/dzl3CAWpuoE0ye+vhjTSalhtbFcRdKTOgMhTdl+5HB67ue8bzCOkHtbjhm7eIzGEKRl/OYfxPdMlX2XHon1RLQ7iX3VRs0/Y
 6XOV4HyQ
 eWQpIGPuhUaOic4EfEjwSZ12aKDoFeeidQHFPi3K86MEozgd5rK389wpFEEZ+76EmWjL+oFoEPJbTnBouS5f2b9eef5295yj/nYhTKFHExBmiiSHQ25I/VFVusNMYB5xkFv3fY1ZehA7YEiWKZXBUylwa2627g8qw2844HHy7DHdFJbKtNWgJ3WPXfPdOZFJU9eEh82CmZMFPerLduYo81j+waJsJ+S/TcG9jQnOzGYT12ExNtikRBDpqKFe/cKmxv6EWT5sCMzk7+f6HND0ubUJgnD/iTYTdyl5IMEF9iDzUs3N7i2eQtmUNLf5/yVx1LKT1yQjzH5Dq7N8wSEb8SVPBI/Ue2spaCCUc4R3GNTvJ4NZGKRvztJDTL61eCaXvin21yKqj13xHjhiJ0Bydbq23FYJL3pRqlAX1G6YI3F7xbPzFv9ZJ+x/60vwGq2nyHFAMjDGcjpH8K6fgSS5R7KZpASKE3CyRajnJHwXcoyoHYFjiQHpF+uLPQexbX45f4BDXaI2M06N0pi7xwHtVQQklVWZ+vKWKhc2/uFhI9tZ2jd3XvJizPcduB29Dm8eLdo9A8R52Oha+Y7tUIaq3rcYXXOJJ4ngF3SXt4Nn9V4HgQdFh5AA5k3RGVyfCGSuJj1pJKYnCfx8WZlerUfDJ2TjViyLOC5K6IFTRfW5/PriKIttmXPBR6UK/lIUU+TsCQW6jB1rPQFDzLWmo3IxUvDJR4eErXJ+8qkLBUYC99ZlgG6H18Gc3+TMJQlFbPcM3nSE9EYBCZOUM3mdRCeFh6d4qLwZe+NL16s50bY0TwuJWadRl5f/99w42ZPdUts3bz46WGU8ukGU5wNxpRxRnlmwuCzpzB9easmzFnWWz9MVfjTAD1yhIQ3A5W7HLhakLMeyLZKRRCqo9v5lBod9z5zPIUsSQnBe5i1a0AR1MNMkWre5uLIbdXGOelgao4L1iRkMeOgAjIuKzvM+YnfRh46PSfT5R
 rmGp1DmG
 Wp/dH+yMcBjEac4rQw5ZEPS2bW94/efj43l41KblvVGQTEzVIqV2ywYBGA6igBguMG5bF317xVt758UHdwoVQVgBPrJoZIBJckvNdhxduUjUrY+wEhR2oRBX7ogkoDlFfVnKQKUyhEV9ygEa0eLAn8oCClyGl8fJ9eOOg7kImFyZD2o6N1FoWUGJzwcip7oKNxGNZm6g0qGOKOU1m3olHWIU/pWk51FkIHtOkZKbUwvTN1dpNH8c4ugVFz6RG/tpSPv1OCUoRcwiEENBF8z4tLX4pd5/tnjQLnY08LXoMLR8BvGvwFGb2tb3QaClWpLK3uOCqmRNbyIrmL7nUqoYvMGwMzrAdhp6yvFI2/+jjTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 08:13:16PM -0400, Zi Yan wrote:
> On Sun Aug 16, 2026 at 7:32 PM EDT, Alan Stern wrote:
> > On Sun, Aug 16, 2026 at 05:47:34PM -0400, Zi Yan wrote:
> >> On Sun Aug 16, 2026 at 4:52 PM EDT, Andrew Morton wrote:
> >> > On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com> wrote:
> >> >
> >> >> Hello,
> >> >> 
> >> >> syzbot found the following issue on:
> >> >> 
> >> >> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
> >> >> git tree:       upstream
> >> >> console output: https://syzkaller.appspot.com/x/log.txt?x=15927479580000
> >> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
> >> >> dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
> >> >> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> >> >> 
> >> >> Unfortunately, I don't have any reproducer for this issue yet.
> >> >> 
> >> >> Downloadable assets:
> >> >> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
> >> >> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlinux-3d6d8176.xz
> >> >> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/bzImage-3d6d8176.xz
> >> >> 
> >> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> >> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> >> >> 
> >> >> gadgetfs: bound to dummy_udc driver
> >> >> ------------[ cut here ]------------
> >> >> 1
> >> >> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
> >> >
> >> > Thanks.  drivers/usb/gadget is the offender.
> >> >
> >> > Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
> >> > memory allocation".  https://share.gemini.google/5NzjyttO0ULc
> >> >
> >> > I expect an easy fix would be
> >> 
> >> Maybe it is better to stop asking kmalloc for unreasonable len:
> >> 
> >> 
> >> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
> >> index d87a8ab515107..20905f254968f 100644
> >> --- a/drivers/usb/gadget/legacy/inode.c
> >> +++ b/drivers/usb/gadget/legacy/inode.c
> >> @@ -645,6 +645,9 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >>  	ssize_t value;
> >>  	char *buf;
> >>  
> >> +	if (len > KMALLOC_MAX_SIZE)
> >> +		return -EINVAL;
> >
> > Is there any reason to think that KMALLOC_MAX_SIZE is a good limit?  The 
> > allocation could still fail, and you'd still get a WARNing.
> 
> KMALLOC_MAX_SIZE uses MAX_PAGE_ORDER, anything bigger than that will be
> rejected by page allocator. This warning comes out because of it. This
> if solves the exact issue here.

Are you saying that if len < KMALLOC_MAX_SIZE and the allocation fails, 
the kernel won't WARN?

> > I prefer Andrew's first suggestion.  If the user asks the kernel to copy 
> > too much data, just fail -- with no warning.
> 
> __GFP_WARN gets rid of all other warnings, even if user asks for a
> reasonable size. Why use such a big hammer?

Because on many systems, WARN causes the kernel to crash.  You don't 
want the entire system to crash just because the user asked for more 
memory than was available.

Alan Stern

