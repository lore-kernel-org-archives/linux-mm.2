Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC3CD26D75
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 16:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3FCF6B0088; Fri,  9 Jan 2026 11:42:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17386B0089; Fri,  9 Jan 2026 11:42:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9876B008A; Fri,  9 Jan 2026 11:42:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBE216B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:42:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57B96D0303
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:42:07 +0000 (UTC)
X-FDA: 84312992694.08.666A71B
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 77D1B1C0006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:42:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GZNoDDVc;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767976925; a=rsa-sha256;
	cv=none;
	b=E8vEjv9k2B3A/C1Z+KuITEC2AZkEIcAM+8SxKmYUXnvVRBEQSCucTb79E2wXSAgnNQf7iC
	VUlWLT0N4YiK1HYdk8HLMMrVs/+heQ49gHFd9/hPSB1WaPWNomMHeoGqfm3ZbC4LGpCRvT
	7UIUJgDpPIk1aIB+Sycs70hORTL1MrQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GZNoDDVc;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767976925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbmVDdav2QXSFlN7+RnQVBBu8vs+yvCmI1lbwcA/MdU=;
	b=Ig0lC6hz4Q4YtE+iZxSBaHBAYPra4Dk76hXhkLSnRXC7NXMo8qQf65RZkBvuh/qhX+RFIe
	MHgtyxVpenopBEhroB1cEt7YyYxQpx6iwMSZZdHXTObqNWadqO/3TnvZwaYDUS/LXSdVE2
	c4ZVL2FphpRDeWEpvaMB13CsmCyZEt4=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8907fb0188fso35611866d6.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 08:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767976924; x=1768581724; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QbmVDdav2QXSFlN7+RnQVBBu8vs+yvCmI1lbwcA/MdU=;
        b=GZNoDDVcWX9GqS4qRNjljdbDiTW2tlpmrCDb8y+Nhc5zA8i/1DXkU0Q3AlWm/1RuyH
         mg4WvFpBYvzxpGvNfqx+JAHaiW0xdIdr4FRQG4WtdXR5e3njeieombBRimlTFk2vnjgH
         C5iEZSXIbDUWlBNy1CKD1VPwA/LyH3o+HBCknf3uHe9MZ4bCnYptT/zhK+so1UdRWP2r
         C2269HsKNerLh4vMLjVZr4yy+JOTFohYB0gl/00wgcYs67qEAd7gz9Bg0SgLvHIcvYR2
         kJdGqk+rDCF+5PJVrlEa4WAbl1Z0upZGqzJ+rudJgDltma8YRwfntzTieddUmMTbD2vN
         uapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767976924; x=1768581724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QbmVDdav2QXSFlN7+RnQVBBu8vs+yvCmI1lbwcA/MdU=;
        b=vGDJe94V8dBrkFVDYlnlOM/C06htuNl6aibVat6iMDHJqz6LQSrSh87xPZlX5A7lwU
         3M5BiAnUkrJ04Qxq0G7fhov4AOQT7FJHMxVEIXn5a1QSleoPCULAFKpBBl4wVtiAjx83
         +dHjyBPG3/V41b6ht+6sGvFeiSRCo8dfHHfh8Evf4T5SjHbMkuzrLRpTkaY3SOjOMJ/h
         BZHY2vuMqWWnNkbDAz7dlpSQcw8XyYm6RjZdIMsLzsosXAyeJkfYtewe5poAqsvQjecx
         ZdZ4gqUJdFCFeLvxCgr0YMuHxhl2TjDGfnROadOLZdRA0WqBp/XB9yf7vOuVVkN+t1UY
         38fw==
X-Forwarded-Encrypted: i=1; AJvYcCXDtQF1UfYRenfndnH7p5bzkNem7pm7SB1mxbiOemJ7s8YTXnMfgpg7CggDfbidvpX2El4gaQ2pSg==@kvack.org
X-Gm-Message-State: AOJu0Yzu5moNbQx5LD2r8fKia53vE0dL2O6RDAi3KvT8VPXqW03ASuy8
	TUMuuul3N+iyavoRiMBYKJC/YiTO57mFqkYelGkhRgOo/Gxnq1z7MCiadkT4wc8d2eX9KNb2pAb
	K+gGM
X-Gm-Gg: AY/fxX40Xp0yh9EujrCrfGU5eAxw7ikuvhUxEnI2Rd30mXDxaczz2OgxK2UVDkgE63k
	n2cEX6jquwtf8WFzyO43W5gZHQ6MZXLIdempAuVjzjQfd8EmooObxiuh9FCJlJ84TtZ3DqhELBW
	A3vhhFED2IsO+TSMePIxXDkb7vN66a6ULEerskTQ5W5W2zA5/cRRdq8VE25fX4bMfyql0weepfF
	SbPRU60e4xK4G9EL+ilaEe8mfk7UOmlViD5YsokaCKXj5w4WHTG5WM681Q6GphLYxWKhaVz2TjQ
	CYhPUN+S4p9FjTj8I6cPZS/wkDwRgahUKjFOCUbYKjBRpH7y9rW8EuhIi9wK+KWr0F+Q9M5Z6OY
	7sF5MjQYSOb3o//hdISp8crZvLpS8azQyRADaieSBRqQI/5aJPNuU0w0Q+RaLzvw1WkulSVjwtf
	GhdMv3wGMrbDYoAFqRcU+2Ft7hTQqKfDM/FTrU5NpNAQoSY55D5+yY+2WMqbLtUyCxvSbM0w==
X-Google-Smtp-Source: AGHT+IHoGMGuBY8eCz/TDiJSI7gOHpMmKKVD0ympruhwdF+nr+92ZedUbdyZt+63pEB4ukVG9TZeuQ==
X-Received: by 2002:a05:6214:2d49:b0:882:42e6:171a with SMTP id 6a1803df08f44-890841d10e2mr144945046d6.29.1767976924478;
        Fri, 09 Jan 2026 08:42:04 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346e2sm81935016d6.33.2026.01.09.08.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 08:42:03 -0800 (PST)
Date: Fri, 9 Jan 2026 11:41:29 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aWEvuS95-7yP-Vc8@gourry-fedora-PF4VCD3F>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
 <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
 <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
 <aV1pmeXP2pZ55g5i@gourry-fedora-PF4VCD3F>
 <fd21ebf7-d016-4729-8d23-a7c0f2a3d8c6@kernel.org>
 <20baab84-c8b0-4c46-a550-21b26b975d07@suse.de>
 <65c246bc-fb10-4cef-8163-3a55bd96f326@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65c246bc-fb10-4cef-8163-3a55bd96f326@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77D1B1C0006
X-Stat-Signature: q5tdohr57gsi8p669rw5t7sdaqpmr1ef
X-Rspam-User: 
X-HE-Tag: 1767976925-480608
X-HE-Meta: U2FsdGVkX1/NPyWZkervru+no6EOWgWcNpd/Nm+GjrxaNKpgbXpwDpl0OKdfoFlDAwD36ombnl0N91q6/XZ3QeleWJ3YgiL+x12EEBs+gIKO0/Nrh6a1aHxnTV6E9KXZxojI7ZOQZK/CIpej9MmtB2EFaQr2caSl6bIhlJsiHoeYDk2w7ogZdAtkQ6wG/8z3xIgKy7FyJvF4wnkoVHtUPQcrUP5y+F/DR4WaX9f/V2VD/UXDowqFaerQBowMeF3bj1W9/a2VBSVZq3WjRgOWUCMZf6YlEWqq5CsK/q/Bl+Uh4Re7R5zdZv3whMop3jKv+Fr/OskxkKOgNbhPOSLnR8XDEOhmh6uqQc3v/6wkulr/bU49E57LOAMsnJuiZUn2szPd1RXezYEeHHk1j8oE0PC8kKEHOJGq8N9Cm7/n0pJgPgeXlrDuVt2o6cOkSBQY1sYEhycl0wLtfuACX6YZHEC46dIMCxQewvO7l4o/+M/3CJ3WVX7hLXiQfPj6rr/PRiKb03JoQZW076VB0bhVK+uZS1aJFZaDeSPA0tKUr8hwnlk28/ckiAxDF9QUej9d57Xzr3hN9z3DulfxuRvId9Od7YU1mLZE6PW1FkIJzZ8eR/tIcdVPJMu9DQ0m9hjj+mcUSXS1XvU76V5rIJYBTR2B+hLQzklBcLSLf/uyoD1uraAAZ17jBZGnlFGfDB/kFl4cTleuXHqpvFurl/0/XXksgTWYmu0mY+BU6FeyqSr6C8dNS7cDaGQiPjPxCkr0LPzjhLSEZG9jRu209Kuk09371T33xINDlbKzSIvr8QL42pKi/4+A3TmedSTA8etzZtOTQeF3Dkx5TxfLFbPJVrcFDQeJgSjejwpLn3Jh+sPqKEcFty2lm7WH/4STNkU+trkJ6FUA/UZaIf6hHLA2rvBIhcT92E31LHpKHgf+g1AIdsraX8CSBzRBPsMLrN8veHZTnHExNkOObDDcnV5
 Is/nI3Fq
 rtOQPYRGF3ZuXWnymZFNPgHKviWg22i24IITlGPWNO+6eYyDPTgC/bbz5ZSwONMCaiVHRnt7L0OcOsF5fDNiv6ZoOd3C6S7hTS2x+JGNGKubj75MKUi33jRyYcyvDFl8WlEIvOPwCUMbNS2bheU1QvZcinmTHQQbzhxNOOZy3FOY66Fj10q/PJGt6jBhp8DiPUNFYqsULfPmPs/VDdc0zZavn3Z8qtZ8xOlh0siuNIUevE4AxFNMT4nQDsDeP9B98N0PfaOsOkvO0FZC9FA61/y+6HnmS3/pZhgypzhr8cjQQ8q3EjaiGrRfhWN93ZDYKITs5VXNQe2OKvfqtW//0mSawMzx3AWftgP4VYSOGxf8KW5oZoT4L4+AKFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 03:16:24PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/8/26 08:31, Hannes Reinecke wrote:
> > On 1/6/26 21:22, David Hildenbrand (Red Hat) wrote:
> > > On 1/6/26 20:59, Gregory Price wrote:
> 
> > For hardware-based scenarios memory will always be removed in
> > larger entities (eg the CXL device), and it's always an 'all-or-nothing'
> > scenario; you cannot remove individual memory blocks on a CXL device.
> > So there the memory block abstraction makes less sense, and it
> > would be good to have a single 'knob' to remove the entire CXL
> > device and all memory blocks on it.
> > Sure, it might take some time, but one doesn't need to worry about
> > restoring the original state if the operation on one block fails.
> 
> That's not what I was getting at:
> 
> offline_and_remove_memory() can be called on large regions, and it properly
> handles whether we have to back out because some offlining failed.
> 
> The issue arises once dax would have to call offline_and_remove_memory()
> multiple times, on non-contiguous areas. Of course, we could handle that by
> providing an interface that consumes multiple memory ranges.
> 
> For the DAX use case, I thing we'd really want a way to just use
> 
> * add_and_online_memory() [does not exist yet, but ppc does something
>   similar]
> * offline_and_remove_memory()
> 

I'm starting to think this issue is actually the result of bad patterns
in the cxl driver - namely using dax as a path to hotplug sysram.

I suppose either we need a `cxl/dax_region/remove` that handles the
whole operation in one go, or

we want `cxl/region/commit` to handle hot(un)plug as a single action.

tl;dr:  Split the dax use case from the sysram use case, and make a
        cxl sysram driver directly manage hotplug rather than use dax.

~Gregory

