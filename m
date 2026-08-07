Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DC7C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C52A6B0088; Fri,  7 Aug 2026 15:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4763B6B008C; Fri,  7 Aug 2026 15:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D466B0092; Fri,  7 Aug 2026 15:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECE0A6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:26:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73CDCA1298
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:26:26 +0000 (UTC)
X-FDA: 85075454772.03.2EB587F
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 837CB2000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:26:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Wc8fl+2z;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786130784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnBfFyLoEx/PS4yB8HejgcyF2TyrFNRyKWrp3MGGWwU=;
	b=MzprOgp46W13psS1w1S8Uikg9YEwaFJiXSYNJar1srDM3TpDqfKXEfFZWf54RvPWbh5xGI
	YfsjeiJb4LAuK+RXmICbJ97MmchwhRxGZWXiQZRnl1PADHUrLV7mRaT2pQpLKR8ZZH99Ta
	aRpdD+tTLWqmV7MDBYmfQMvdgj/x2EU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786130784;
	b=hAMAFl46cW/topmmA5FRpYORfiaoRKf5Q0Q1KCZlFW+bGe11UbLy4bg75MePzpAbVctOMk
	UkMmbjQhJ1dAP/QVusGBPImlkko482StwlBC/fTbjvAo40v0HFKaI59V7DN4/CEpd0Fn63
	DPmsHb1WiKTl6+L+NTZW3IBgqDlKtMk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Wc8fl+2z;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c149c5722so19859071cf.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 12:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786130783; x=1786735583; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BnBfFyLoEx/PS4yB8HejgcyF2TyrFNRyKWrp3MGGWwU=;
        b=Wc8fl+2z+hL+sxci/el9K8ZI+jVeCCXqzDBuxFcIY5baeFoOsXM4xg+CYnusPU7ihB
         rOt71aXmtrXuDpe7v8KGGoH+51U62f0Kgp28ZcUjRjx+SCMtJ0Mh5rxcE0tTyks8WtzG
         mDFRFDJly70l+kZ/77QU5YIJQDGFifbymB8ENAJ7udh7Y+jYIimp6nFzWyedt5O+KHfB
         CPQ8W+TesJCWKGJbAq6ByZ90kvfhTjXySTaNaPYkZZE5QfFL+/G2dADQFMIo5AZ5GWmv
         5cHXdSIDV+8yE7xxT/juFdtpbBuT3nnjA4IGUaeKP2xph+sSyDtRDQUayiKaMZByrxXu
         VgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786130783; x=1786735583;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BnBfFyLoEx/PS4yB8HejgcyF2TyrFNRyKWrp3MGGWwU=;
        b=DU/ATXKmPfJjrlQJOd573k5pGHfvis9sTVVHN2EX5BPFGcdBDi747counaf3LLz6Vg
         9hFqnht3i/Xi40glj6Rn4sd+c2Z6B+HhXvk9ggrCKw3QXX9H5NcnAV8h8WCffy3PQ1Rj
         x7M+B9s+poRJSfTjZ08zSPkSlMPjCUHWbF2J7DqBM7DwoN+mPE9uSjkvN+HlkAcTrKjr
         V0NNReNx+6Xq/vK6FvPFdpDUb0wU/tZF90JdikZiXX/tL8m+R1By+xnWosIC5oe3NC8c
         9H5do9lBy9qPsX5Fl/ocG3GNIgl+xV5yblkwvynOz1bXnz6K1/dChpPaFURYgHc4oHiD
         xl/Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro/qyxdrQ+3tD1UupuqNKOTSk87myWqgoleb79vxnHtIb5CaipUS3DVR185VtxgWExefI+zE5ScYA==@kvack.org
X-Gm-Message-State: AOJu0YxZAt5AqfOTfVH506IYfBAQB/9t2HksUggKEkZw8Kzej7Oveny9
	qLAV2v+O7rsiqOWsayHHkeiBHqWpPxN+z8vF11hab6G7vKLoZqY99E1uNufuEwhnGKQ=
X-Gm-Gg: AR+sD13qog00YTQJzgJYAAhEXs/d4pqZEizpIEekfjwq41kVgu64ripXNzADuoJllaI
	07e5pPukuqjwM9BkzGOdg29ffdR4yOGk4JVT/1xg7K4Pb7x4V42cmzzz1+uD8KwLvmtimTJf4YW
	Y1oX4ryapqm/Cw1d6/3VSIz+UrfHJyK8rmiju+YQqN/uEhZgpDoQDMf4HcFKz2ypFBHMBHyzzAH
	O253u9JZ6uKhxD1FzLgTcyBLM5MQWbHXZNXY77omlG4KGxLBGkgJAsr4j2t/uwuJ8ba40OklVFx
	1OpGBTLu/OhObspLEEbPTe9naNfEGGDtZJlbgPEB9qaHD+URo7T0b9ilnC4CsK4Zyeyr/QU0DBm
	7Yoydq8Bz36i9Yff9F+TiORoMKJTOwwx99rvthwh1Rho8KSjKV4e2uwyE+MRYwcl379VpyxKqu0
	WVBLxRJlEDjT2X1CMRG9VAf87V5/9cGDEAU36AGw==
X-Received: by 2002:a05:622a:1246:b0:50f:c403:7ffb with SMTP id d75a77b69052e-52d237a7734mr13432901cf.18.1786130783658;
        Fri, 07 Aug 2026 12:26:23 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d163d9107sm18654961cf.13.2026.08.07.12.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 12:26:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wsQD0-00000001DxM-1yq9;
	Fri, 07 Aug 2026 16:26:22 -0300
Date: Fri, 7 Aug 2026 16:26:22 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, jannh@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Message-ID: <20260807192622.GK200537@ziepe.ca>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
 <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
 <20260805004619.GA28508@ziepe.ca>
 <5cf3542f-fca7-44d0-8a17-8aa316b1fb12@kernel.org>
 <hg73nwj6fdkqect6xzf34i7e4ki5izjyzb3lz6ery62sq3566k@i7tsboqhsdxd>
 <20260806154845.GF28508@ziepe.ca>
 <ulmrkvrqbxqvri33y2olv6x2xjahb3yuee5vcgaojlxhl75gxs@ihjkaias5kml>
 <pipldkadm5oy4olwticdjqfjz4ccn7jfqo3tdle4n2b4jtfmiq@5ckyybqnyk4m>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pipldkadm5oy4olwticdjqfjz4ccn7jfqo3tdle4n2b4jtfmiq@5ckyybqnyk4m>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 837CB2000B
X-Rspam-User: 
X-Stat-Signature: r8abf6cobuaj8ws6xfryciwpo8ofyb3b
X-HE-Tag: 1786130784-335844
X-HE-Meta: U2FsdGVkX18vns3S3T+QpXDJKfBuaZro4aRyi8QWiHfuB29PMDDYd+krMwYUMJ9itwdGyOOtrlBSjA9AHQKpQ0kfNGx1N6NGcP3GxNHBjnzoDtmdaeOLAgJcWb00nH7oxoW02hv+eQmdYpDgx7ZEeAsIOiNnojNQcamFzj35sGYG1Razs8hCisQvqVXgDkKSwTZ7P9buE5qqfwjc2MFZaIna/TuPDXF3eRtOtleOin0CE1XWn88PcTqSlQO/TqgBB96yGFoAbq/rdifWYCZMA54kxyNse/Zj3enQPlG8DVBunMfAZRh6LsOu7ryeBiC1BTY0qy41E33OFxqMkilB3TkdyXHpvrk4KVWmAAtJtLe6USiVMUUA+2xjnbXA62v76r65PkhKONkPBmEz0de+YogBPNK04fFkRZJ1GaC/W2ZmgOb5PfZtyT+Nj9HX2eijoUElBTSGNaj8Mnq9UZJ2HlRTpKgAkTAQJWDXikb5yf+zBTY6zOhyCyfRJP1HpsbTWJn5UXMYjb5+s6wLbHEdkOiZST+sFzWjBnVeNarao8ySbTmdeq6WumX87cLaHaApctU7yV/DpyOIQEfAOD0umACUlpNyQHzeh3l8eIKvPaExBWsTvlTJFG3JQDDUSXmtF8+lYZnB3P3wV6qHEEZ9/liSrVC0dpBvDB5jIhncjwCTQHvelQszhW/FhWgc6TM8yHJU3SIB/ODDVGO/JdF1zOCLYLk7XZwa4FNjmcJa1zQYJ0iAQpeI/NvBCfgKv13bZ7QnZXm6kAcWkwRAfs+KeqeRUxLEgOOFD8A0CP2Hw098u0SrlzU376nWfPE4zwTbLoGQscdwabrs3SzM190ex+qciPpSrzNi97mAQW+PavlUwhuQt9KPeZ9IJhgPIXk6gytVuiIoaJQhrcjZ6Ecn+wh2QCIQbWRbycOullaMqm0F/oFlfw+AqqLXhcu2yKc5+ORiYf3MoVmeGSdK9Qs
 ZS5KLeOY
 asJ0F7S1fG9HKG+nz3aBl1R7TCKsWbgfwf8aowvrzPAUz/6oNUe9wvplAofAgBB43urRLcQpFlqdLQW7QKZmAoBaIJQY4J8MyB4dH90LVm0kd/VyuN1R6IRgURlGDF/0cTbcgv+w1S52JxMaeTsShKAFtd1SqKLhyqdKQlzpYhCvhiUvgs+YWuJ7BhMiIzpXPZPG53pmzGHH55pBgXWpnHCl2PAHolQcuVFguiGHHMpEgRuF871gUfvdReuyogUVuMTlvzZCFD2RmzEj1kSxwc2JgBgg0Kg1OdWcv4j0ljNM5YUGO2xoJy3vOtr1QPdrV2kiPkFnwDoi5GEmzVtdHgGnpyZtRA0qIvYh9lFDeL/XkEp9hplL6dNoGi4RaK7I4zs9ltCfCV2LG3yocdKB5KvBLEgRxFQeE38sgMSs6rRioi3X0LLlSxkrEozo/Tt8JSccMeGJ3apWlNcCh86griXSG1mez6G8HQo+zxuAHZAN+gDBPOrpssQ3wZyCDFWtheSBO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 03:24:24PM -0400, Liam R. Howlett wrote:
> On 26/08/07 09:19AM, Liam R. Howlett wrote:
> > On 26/08/06 12:48PM, Jason Gunthorpe wrote:
> > > On Thu, Aug 06, 2026 at 10:29:27AM -0400, Liam R. Howlett wrote:
> > > 
> > > > @@ -5609,8 +5612,7 @@ void *mas_store(struct ma_state *mas, void *entry)
> > > >  		goto store;
> > > >  
> > > >  	mas_alloc_nodes(mas, GFP_NOWAIT);
> > > > -	if (mas_is_err(mas))
> > > > -		return NULL;
> > > > +	mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL);
> > > 
> > > It still feels really weird to ignore the return code from mas_nomem..
> > > 
> > >  void mas_nomem_nofail() 
> > 
> > Sure, that's fair.
> > 
> > > 
> > > ? and maybe it can have a WARN_ON
> > 
> > 
> > The warning would never trigger.  If the allocation fails with nofail,
> > then you'd never reach the warning.
> 
> Upon rereading my reply, I don't think it was clear what's going to
> happen here.
> 
> If there's really no memory and no reserves, then we're going to panic
> on trying to allocate.  So, even if I rewrite this to have a void
> function to print a warning, it will never trigger, at that point why
> have another function?  Are you looking to document what's happening in
> the code with this?  If so, maybe a comment would be better.

Yeah, it is clearer to document it with a function that can't be
called wrong, IMHO

Jason

