Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C0CC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9D46B00A1; Mon,  6 Jul 2026 04:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AB96B00A2; Mon,  6 Jul 2026 04:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222E86B00A4; Mon,  6 Jul 2026 04:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFFF66B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:44:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E48B1A0330
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:08 +0000 (UTC)
X-FDA: 84957714576.17.BEDDC57
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 299B91C0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TQ8xpR3B;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLCqgq8bJA3wDjgxn0V0PvA/+/Oia2v1so+e3G6fRBo=;
	b=NKKIY3aR12te4yknPJGJgmNraJGgwhqzNBcvU7Gk/8naWS/8doWme4R7CDtODYzPIDmbV2
	5bM0EvYtFsmCY+a/JpC/bpjYV0qgVEkvi3vbgB7HH3eap1wpIIz8YX8vrjoNoQHtfx4hLz
	SSyuyWEvgrLNGBguF54SYuFCnJdGh+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TQ8xpR3B;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327446;
	b=N+mbDZtVbaeSBihlXo+/Bc/SuV9rxSuCsMaw/Ep3uH36UhdgWjRWLAo7nlSCWA6G7e0p6r
	Qda8CLCUeJnvPzthJUeL4CzdQiRCr28UE915G65wK3nny9hhJva46TA03wnfghFBZbayDz
	0gfZTUVfCIyiy0KRrWjtp/oEGQuKBso=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783327445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RLCqgq8bJA3wDjgxn0V0PvA/+/Oia2v1so+e3G6fRBo=;
	b=TQ8xpR3BtfIHIjkL6h55ltfki8UrsG+lzlNzk8Pjddr6DWTUFYRJevKJWSNfR/nfw/OLhb
	0zSqQvGZwp4VvAghkjAXkqEll9VNTO5QwDlDF4guKl6+ofI8o04ecOZUH7+GuZx7uH/Vcn
	l/rg7kJ/p5l/Gl6pJSgWgcPS+ocIT1M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-2ky-Hgs7NBi_N2oh34xpgg-1; Mon, 06 Jul 2026 04:44:04 -0400
X-MC-Unique: 2ky-Hgs7NBi_N2oh34xpgg-1
X-Mimecast-MFC-AGG-ID: 2ky-Hgs7NBi_N2oh34xpgg_1783327443
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-476608a9fefso757434f8f.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783327443; x=1783932243;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLCqgq8bJA3wDjgxn0V0PvA/+/Oia2v1so+e3G6fRBo=;
        b=oPAGs28fr2xZM+hcN56NVTifv77gm8cYsUECQwDWCknH8TZ0vhbKb6IqXUEaQM4YkN
         NeyFGL4NuhUVcd3YphwvdGhzBfBKKPplelkZSHbDb1109+YkuhAaUh0nUGevpGT30Qw0
         1wXmSMXIsKzDvWYklqrM3L+toJT0etv9FGZS1jr8auLNC3TZXW6hZgtfwfrrTRXxt4VX
         BUeTW5dRbiKs5VJYkX/5/yGlnUECTTh8oO+5JApLc78smbobgCQWcl4j+UaS4FnB/Oks
         Jn7ss/XEOst24P9wCIzrLzG/qkgkWWj31s/YRVrdjfbKGULcAd27MdSDWxdVNy77MZBl
         Gk4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq2m7GlzojmY0Ll30bUuvl8D871MEhFi4iZkv0tVA7UW4sRrXUlvm2oNsmfrwHEtRp356iNbwjGLQ==@kvack.org
X-Gm-Message-State: AOJu0YzT7ICYGYoWIRKa1RqhzYttP7gpZ7BDaXUe8LcfMudz3cpYmlcS
	CMIaIZnLB4Fijw9BfZ4NjDZNzSRfL2zVyJ99Cc7vBQHCngiabAhDAqcinCxe68tcm0vrshFDF5I
	GSa2L+VVie9ZN/LyRAKdq0zV7txtAsSL+uHVbT3IFtgs8nbleWywr
X-Gm-Gg: AfdE7ckHgbg8/YOub5X5hYZyZngfdwWK6CMrE0AhgnaRPdDDVKFdvsr4z6Wl9Rpytwk
	FsvyeMaq159rWeiMl3fqR7YSKlReDbEjiL4fHHjKmMrp2yR0R1tmcmNKURSv4iARelYAhmiTmIk
	ZCmluFXUSJbKgify+MvAdJbfPmfOevxeGIDQB3cP9Tb9Vi57fcbUIqPiX7WDo0csOAUEp4kidTu
	W1z477XdZALAR/f9OdtShJxESOpAItxl6zR0mGir1+WUrktzHwJ5jZj4Afy+CsJ0Q9yUj8hUI6k
	i9PvfblTZkuQkjBcaBJEukTVbIlvTXK2utFlm26FvmHLvqc2TySEyNcF8q3dFB+YwPLCRACBwnl
	/cJLM94hJaP6dj4+BA+13+43k9iAfnD5T
X-Received: by 2002:a5d:5d85:0:b0:473:6590:c42a with SMTP id ffacd0b85a97d-47abad9f1d4mr10815765f8f.9.1783327442856;
        Mon, 06 Jul 2026 01:44:02 -0700 (PDT)
X-Received: by 2002:a5d:5d85:0:b0:473:6590:c42a with SMTP id ffacd0b85a97d-47abad9f1d4mr10815728f8f.9.1783327442334;
        Mon, 06 Jul 2026 01:44:02 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960af0sm21194916f8f.30.2026.07.06.01.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:44:01 -0700 (PDT)
Date: Mon, 6 Jul 2026 04:43:59 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Adam Litke <agl@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] virtio_balloon: prime stats vq after
 virtio_device_ready()
Message-ID: <20260706044122-mutt-send-email-mst@kernel.org>
References: <2f0d0de033f3005d3b985883be3e5cf37b3f6c42.1783278596.git.mst@redhat.com>
 <13794c5e-375a-4fc5-84b4-a637d077f8a0@kernel.org>
 <20260706042207-mutt-send-email-mst@kernel.org>
 <6b8e4ad3-6909-4d0a-89a4-104a5ad9fe79@kernel.org>
MIME-Version: 1.0
In-Reply-To: <6b8e4ad3-6909-4d0a-89a4-104a5ad9fe79@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EGD-mW2GNZPTVZmsxfg5tu221mFFoYN4HwdO0tX4MJM_1783327443
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 299B91C0002
X-Stat-Signature: j6yqotprct5g8faagxrrzkuxmuxjtweq
X-HE-Tag: 1783327445-656508
X-HE-Meta: U2FsdGVkX18jGnE9BFPGcGaOddE4jot0gtkigT/hHYf7BQ/HgJR0YFMjVSkvg8/eDUqIz43H1Q3syR44u/3j1xyB4lSiEKw6qQEvrJaD3rkDc6LiAGfFcnsYMsLpVGXeP5+hV+gOUaEblF1JuXyhhchPQJeNADaRTZ7pwgwHng1OZBuAdjnVX9V6hkU9F73OAX9wUU3IyLS3J2BzvqfwrUvJOd01KPg8QdM7dqYol460xiZ4DuAsr2IOezsEjJju6r5hKNTCc8pKMM+fi2/FDQZ/79pdgClxVt9rMmX5O1/yo25LNEKq66GAKmxqKYMmvrkJO747gdUWosygULfzeszwCMiu7UonZcsmx/NVqx/IvPPRqcNMUmEGsCzoVtcdSsqL0iGOOeLDwO72pfUFf/9UIUKcTwwWemAVgP2BHQemIzcBG0naYafZQcRzw5chC0I5LKzCGExDUc2uV1e0Qex1sSh6zW2ri1rqiLk6g9sKNtIhVELBo7WhQ0irS/StlrnrPRnEg8OdbFI778+U+Mwo2+vQeJQ7tWFTAzwvgQZfglpDqlKp1QgkXDSksfHMUPkVVvub/TGEAfhX10GHAsJX8zHxQrrJ5rUBNzzDR4OkmgoSx8c0uHg4Hxblp1MH2Z5v6PdwwTqEL08jiMKe2NN2Tl4WNEgRgG4RvwUF29Y3ghEQyE1/G4zrBNnsVmO7sK4BCehTz39QtQ/VI+KpMWHIqVcrBVElzE8oCocgwLdWkx1TXW+04+/EFJSrhxd7MfxCJaJn/LjL3aE9Q5CZgL9fZsnaBLlD1IHQfXkOW9h0hxfhBzSWyihAdhFt0XZidDIg9qTuopZwN9BgscnvJctViUVPydYRlMeh+Flgg6JNMSdVvoUYeP3jg/TKQvcK1P0j0k3OYS4i2Kn6WhyrV7yW3I+uGMrD7IOh7v5Xe3907Got4gk4e31eG70Q97pF+TN/whzx3QRuNrKbSCL
 jaGiXjrf
 N3uHMVCh5mrJXfUGzQv5q2weoxsyZ9sGaKPDXY8h+g3nWNgFrICkIf2+048YAGQfIVeR+Yfn4K3FQ5U6HKd8ZH4o3n7LOktcPatgNDUH1IkTcSbUDggc18+Jjc4tDD6LrRzV14R6oPYQZdFd8gd+qACHKUhWu4/7NmePu16ywApFTHfk1NeB7SZoTovGCDs2Uzq4ViFWVbL4PW1mlgr0F0fIeTrAHPbPsdmvGONUJUErJnJgimdNvlaA3R0wzek4VZvUFrv6wD0qJJnVVSWgBiXU+LRtAtEyBiomEwKWCwXFoUwNTIL54SpwzIzoSWg16TSBZ13FGzkWijdtmLCy9FDOsFj8uPzyf9FKDl0MJGaLKMl5JTDm27NUKXYzByRfnyFNl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 10:38:18AM +0200, David Hildenbrand (Arm) wrote:
> >>> -		virtqueue_kick(vb->stats_vq);
> >>> +		disable_work(&vb->update_balloon_stats_work);
> >>
> >> That's to stop the stats queue triggering stats_request() I assume?
> > 
> > Yes.
> > 
> >> Is that
> >> valid before we actually added+kicked ourselves?
> > 
> > Why not?
> 
> I was wondering whether the spec would state something about that.

Sorry I do not get the question. Virtio API expects
callers to serialize calls for each VQ. So this just prevents the work
from running and accessing the VQ while probe calls add_buf/kick.
I'll add a comment explaining that.
But it has nothing to do with the spec.

> > 
> >> Also, can't we simply handle that in stats_request(), just ignoring it there?
> > 
> > Then we'd need to maintain a special flag and I dislike that.
> 
> I was hoping that we could use the device-ready indication, but there would be a
> small race window indeed.
> 
> -- 
> Cheers,
> 
> David


