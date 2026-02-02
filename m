Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2FFE7DF11
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE966B0096; Mon,  2 Feb 2026 13:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199296B00BE; Mon,  2 Feb 2026 13:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B916B00C2; Mon,  2 Feb 2026 13:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0F6C6B0096
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:02:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D462160277
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:02:16 +0000 (UTC)
X-FDA: 84400285872.23.952FF5D
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 279501C000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:02:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ELaHywJf;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770055334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMO26NJqLzUacsptvD643N0i+a1yKYqxDegqXwZutbI=;
	b=dKImsrHWq9hAN7enXhluH6mf3bxBQugUS6y2HVFigQLUD8m5SJMeOd2ClNGhGmFVhqJCBw
	/zP3AesJIkcssf5WCyAHCYv2r7n33Nz8iBIFIRuJaFZoxxZ6vPSeqNxUud8zN6BcN2HdRK
	noexpppURGpJkTq7HC+f8OUAZDSN9fA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ELaHywJf;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770055334; a=rsa-sha256;
	cv=none;
	b=VNnOr1sFMjfB8/76DVGxiE/cYcuoijTUy3SXyL7DVWu9ufujP/tc61bQ37nyONFVwSnT1P
	kmBmIs5VBdYEQ29BfIyFjIoGsnn+xd3YwMOPPQftqo/d57vBeJHOtI+qThVRR/1Y5nu1G8
	y+aX4pV/svl8v+mGn/3/XhEXbPGQvdc=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-502b0aa36feso50717081cf.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 10:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770055333; x=1770660133; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NMO26NJqLzUacsptvD643N0i+a1yKYqxDegqXwZutbI=;
        b=ELaHywJfx9znR4JscWR58lVt3c5whgRTs9Qtus2j/rA/YMt3KDp68lwmcVMNlT15Yg
         vv0H6jP6dOF0HI1EBTYe2dI2fZ6p0KMbqO8sXy+VA1t77l78mIXvz3KL6e90xjRrgqpY
         z5YF+aC2UjzgRH95ZUWuZtxlzscMuBCCNSj35qiMADQZ9XEB2cZM73t+8B0fHEtzcYTT
         7PxoYMKnJqz7j5PbzpURF9L/YgoaPbxRY1yibph5V/Jg128V0UM/qd0dMc9OvaC9HPqy
         N8SWaPmoaK9aUXTN5pmezDWnjPRZ4oBkBqIkbE3ZuejLPCtmWYbU4Wvmi9yqcUb9y+pa
         RSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770055333; x=1770660133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMO26NJqLzUacsptvD643N0i+a1yKYqxDegqXwZutbI=;
        b=omdolsFLG9RU1FiXTlm4Isi6+uk8OHCithW073iVNkbBfsF/coh+uJgNiMcM9ojn6F
         yjuHv7iFYIxiFibZOMjgNlHhtM2404W1mZkRO8UiT8+PZ6qcg47IL6hGdLoYgXGuU7rS
         CL6P7yU5doRSm70DpodFoKe+mypHImzEFhxHpEARFnW6CPbfDh5pt/t/Efo0wbHP2wNT
         NbQldSBa+SNvEyzB4yGKsc7HKRW2f5nOcSwt81PMI/a4h0WkKtRZAb7iqYWxzaH76gtI
         myta8Ng8w0YbwHPe3cxPTh3mawVmctftFWURCmmM+NVpGGhvouV74UzBqcDz+kfV85W3
         1VLA==
X-Gm-Message-State: AOJu0YxTq6/ImTd4vNX0QYf3VnMrSh8wed97C01tk1egJD5m/A1lrpHV
	WnWh3umkH3COF042B1AL71fQTKZeCg80VgcxNBGrDZQD7aenvPALVcxE7E4j7aow0b0=
X-Gm-Gg: AZuq6aI8+MNpyK8ei5cnjd2fq27GxTJw8mlECRm3pNVZcvKTDOu/xv9GVnPL8QcB6RI
	0KyiSMblVLwq+gUnQI280G5ERtTtwLs2kASlNBB4tc47CPVxRTKXLd5ymwoVD2S79UEz5wy8BAD
	ueqGDSjeGOo8Hk1ZxcHUnODGav34pTHZreKVSR8BQDtWT5Z7hkMTGSpnyXzzlcJ++r2HFC19WtY
	+L8gc9EfoaCbfdCSbkiBnI5x9FSxiCaUbDWsuVRJpp4KiGYtgPplDy4OI7d3S8yTmssl5E9YFJ2
	por0P0jrDJ8ED83lN/BAX4pMir0nBXn4OCbBmU7Kf3iktYvk8wEJhdE7smn8Yqx7hNP9PsrG57n
	IwxFreKAHoHWa+Y3g+J7EkutM0GzF2YZJVwjPaFDd2s5izLghzAomX6xltxyMXeAvjeocf03eZ7
	eAidJdXCAAiYHMc/ZmqlfUN+1SzUQLzpqA+UYbUcefyOWL2Evw9BTsN2I+lNqlhXLO73pCUQ==
X-Received: by 2002:ac8:5a54:0:b0:501:45d7:10cd with SMTP id d75a77b69052e-506092c7f24mr3163751cf.20.1770055332821;
        Mon, 02 Feb 2026 10:02:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36c5430sm119862196d6.22.2026.02.02.10.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 10:02:12 -0800 (PST)
Date: Mon, 2 Feb 2026 13:02:10 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed()
 with online_type arg
Message-ID: <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-3-gourry@gourry.net>
 <20260202172524.00000c6d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202172524.00000c6d@huawei.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 279501C000D
X-Stat-Signature: uc9no6iy1nspo5f1bag4ohw7iqpmorwc
X-Rspam-User: 
X-HE-Tag: 1770055333-811648
X-HE-Meta: U2FsdGVkX1/t3PrgqiMfUAudaT/ew3mMBXWYnTm0QS3GWbCQC4B+QV1ajZwLybnFl3bheaxBHj2Pnbd+PThOkEXL/8WhIKbNytzVZD1N7ounnSN8wlqDZvvMrhsYpV03PgfZbpwMJsL2DkrgvIsc5B5eOuilCrT0KxWrcN/hUpKTHEjKlW4yTxUGlHi7tvzQpDaB/SM0Z6+WdXrwnbdr9SnQKH1blNw0P+/NqyxNwXglvGWLmJ1Hw/v4cpiOBX2I9UU7u696PF83Pn81v/kC1T3R+fjUPoUZkkPVBwbyu6raDguG3f2Q7r6rruCpNgIRqtbJFkV8ccFTH+HbzE+arNie4j4beGzeUAcQcY9zvAxGguTA7KvgM2Hmpog701d6s7q9wykFxO7fX1/IBaWyHlbCnDKBJMHDbN7TA/Uz93byLoRJKaAVRduNxvG8QF+1/8ysVSW1okJFNVQhZVzbKEbVnVKMggHTUzeCcneIo8aXVELE9LKnqQB3TCebeuO1qEYlXnbieZqEVQlKJzNiNjCmWnH9BdU0eZLjptB/j34kWqAukqOzUUmPQtp63ijUEhRO0QFHmcQP7hFzcl7WcDhRxhybMN0QHDaKWlD1BLSB+iv3Oh8VAhnKIyINEc84N/+4sy2Bj1/ANJD6QPcNsIW9epbnPLnSga2OsLIBVKuyvlU1FsVlhunAWmAgbfmf8mz5+YJ3fpFKhY6sA3Hfxa8BTOf+YpDIQuDvoaYDijWxStTTbYhEIHeUYAq6RscCSeulljQ0AotrhtCTE2DhIqJpDyAuIq80pZCEobxlv4bkbhV6VOOXlkFGEuQnw4QisZqptgHwbGspHj2waX1zg95azdV54mZwjyfQblmPGk60twDTeu/obTh8LDc1dYLr1qAbn3FMJyFqVHV/mk5/DGoDO4oCSRzPUwre/vSql7YcmJCNSe4SWMxvI2Yiai7KA4kB8wunRgw/l/fdiBw
 ZmfSJKPV
 bMklSYl7Ft2eLvLDqwjg7Vtn6L9oF8xZBZDbaGJYhOIdGxPFlQlBWI88tp1fcdlziEdOIuWcbHkbUqbktPaZzwtDcqzNEmz0vMjOMN4t1d1bO/Cb7jjzmKoE1y2I5+GsghtSs/EiZ6NU2Hmof1MmwTjSq3je4Y9ucngS9DWfBFg9evvW78ui+aUFvGKMUCgA2Msb0l8gssUdA4yYfE+9Ce30pFNWID20J38W2rS1RuEWhi3nt9wox3lgOLa9emC146ut0q0KWVE1urKrL1NqlmX/oBH1JULmg7gOq7rTfEPJ51DskVdX4a3+wuJCBN9LdRYXIkrOO1wyrpO0DJhWyCeUf3Ycfz3lHACJmk1aVhDuXBHIDci4lHZtkoado0uswJFeKYDqGT3L3qmjtEjgK2qVUWFbeWqGQ03KeUR+ZOYZvGy6hs6NoptdbBLXfiluG6kKRwP8SZuMDGOXznHs18ngKG2ZwzNsd8cYLRhyEroK4BhUO+GOUQC5IJyZyLsQb2HcMGe/DUvcINAI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 05:25:24PM +0000, Jonathan Cameron wrote:
> On Thu, 29 Jan 2026 16:04:35 -0500
> Gregory Price <gourry@gourry.net> wrote:
> 
> > Enable dax kmem driver to select how to online the memory rather than
> > implicitly depending on the system default.  This will allow users of
> > dax to plumb through a preferred auto-online policy for their region.
> > 
> > Refactor and new interface:
> > Add __add_memory_driver_managed() which accepts an explicit online_type
> > and export mhp_get_default_online_type() so callers can pass it when
> > they want the default behavior.
> 
> Hi Gregory,
> 
> I think maybe I'd have left the export for the first user outside of
> memory_hotplug.c. Not particularly important however.
> 
> Maybe talk about why a caller of __add_memory_driver_managed() might want
> the default?  Feels like that's for the people who don't...
>

Less about why they want the default, more about maintaining backward
compatibility.

In the cxl driver, Ben pointed out something that made me realize we can
change `region/bind()` to actually use the new `sysram/bind` path by
just adding a one line `sysram_regionN->online_type = default()`

I can add this detail to the changelog.

> 
> Other comments are mostly about using a named enum. I'm not sure
> if there is some existing reason why that doesn't work?  -Errno pushed through
> this variable or anything like that?
> 

I can add a cleanup-patch prior to use the enum, but i don't think this
actually enables the compiler to do anything new at the moment?

An enum just resolves to an int, and setting `enum thing val = -1` when
the enum definition doesn't include -1 doesn't actually fire any errors
(at least IIRC - maybe i'm just wrong). Same with

   function(enum) -> function(-1) wouldn't fire a compilation error

It might actually be worth adding `MMOP_NOT_CONFIGURED = -1` so that the
cxl-sysram driver can set this explicitly rather than just setting -1
as an implicit version of this - but then why would memory_hotplug.c
ever want to expose a NOT_CONFIGURED option lol.

So, yeah, the enum looks nicer, but not sure how much it buys us beyond
that.

> It's a little odd to add nice kernel-doc formatted documentation
> when the non __ variant has free form docs.  Maybe tidy that up first
> if we want to go kernel-doc in this file?  (I'm in favor, but no idea
> on general feelings...)
>

ack.  Can add some more cleanups early in the series.

> > +	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)
> 
> This is where using an enum would help compiler know what is going on
> and maybe warn if anyone writes something that isn't defined.
>

I think you still have to sanity check this, but maybe the code looks
cleaner, so will do. 

~Gregory

