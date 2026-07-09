Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E132C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 21:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0296B008A; Thu,  9 Jul 2026 17:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C72E6B008C; Thu,  9 Jul 2026 17:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF686B0092; Thu,  9 Jul 2026 17:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07D666B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:58:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E2D01202EC
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:58:06 +0000 (UTC)
X-FDA: 84970601772.13.BC3C4B8
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id BE8D240004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:58:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ds27pOLA;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783634284;
	b=mA1drB2kQ0nNQyMHPz4QIoDswP9QZiegUmch7I7x4chW4hw7pXfgI25EI/F0Jwk/Dx+TOi
	2TZfzw8XqPinG86J88JCFcy7ID0TusFbpKoG1yE/lmP3/bukCj4J/SEWALBVjvU07aZgxo
	A8CRn8OZ1l5AZqJ9tVsHWs9KXD8OFNA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ds27pOLA;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783634284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIyfo2VEcxlnkeMECDcWCS4lIF+QfUGCzzimsolaQ9k=;
	b=JWYiNct/nG+PCNXFlH+RcuJtxIlrO6mXfZMgz0alFz4bLdV4sli99nWIHMW8QYbGZFl4JH
	oCR3/IO0TMI1diLu9aCqXnu+qCMEqXrOInvpVeVcp/IHQeygdKlB4YmJl9Cg9rFa588ohu
	ZwGCWWHuj+KLG/1wVOjA+gTvGVstysE=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51bfad59921so1777741cf.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 14:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783634284; x=1784239084; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rIyfo2VEcxlnkeMECDcWCS4lIF+QfUGCzzimsolaQ9k=;
        b=ds27pOLAfUiN1NIbBa01frO0szVD5fuiX8BYcGqEfqdW56KhpZJ+7KGiL2pX6VkVTB
         21ldcLDc/O84PYkP1iMNKQY/dfX+652OETfMMeHj4fenoXAcN0Mn6OXhP1wd/hihRgie
         svVbqdw2Z9ovF7mqANKY/zagi0awImuuMtpXJHI5rNxvccKYoNF4nAEKu3IkLu+i2dOx
         k19k6+75bAcmJSG/KX9CYApxCLiL610gigculmmPJO+T5xg2P27c6H5SW7k+QYPc7hQ4
         +QvcvvRZ6fWiwFGyT692njhxB+13eOEe7dx8yjCrZkEquD3OaXJFT5+Cchmpbg1D9m0+
         +j6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783634284; x=1784239084;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rIyfo2VEcxlnkeMECDcWCS4lIF+QfUGCzzimsolaQ9k=;
        b=LjQQhwvBDV0sETzc+/1bB3WzThq2ds2ejMwC7akJdfEXgr8agMDdcfEiEIGZ67gCDY
         8Sn/0p5z6DC0rKH+6WFkIugBcL/5QV5qZh5FDUOljlzFgird5nHZ7i9t23q+ennQFyt5
         aiLjGy2aWzhxbglIQFfoKkwGuwmqb6EoG0WDvKUCSh+ejYLkBfRgOL9+KwtwEPnG+JDI
         9+8IpIBsfd1Q+kUF6E8GKw4UkjkSGd9d2fv6Xavu90yaSOxk6FR02CruG7ACBVy9Ttzb
         Wced3BiRqO/X2KncDXeUhta20SU3TIQpGKJWCLWc570pkuItoLERQJw2XLO85RMmUa+A
         OnmQ==
X-Gm-Message-State: AOJu0YxckiouxZ7iOowLNznFiTTa1QcI/3gqq8UQUbbFgFsCjbOpNssD
	ayLqWJU4Wv2tjTJPVtMmqyzQ+HdgNiXL8k50HLClaWuBiNiE8jF1oTGsoiPxjhzfVzc=
X-Gm-Gg: AfdE7cnyNsiueCNZ6fTT8/C7E34vNTyWPbKHU6exmHx9hDymY7Fv915h8JaRPAKYhNY
	WXnd20PLKHfo6JjZTFoOYPO6lIF8559Wi5X+2rt98J5PBSBVc8EGk4bQpU6b5stru5akzd7Bj6m
	DIsWIm6LI8cWcMup6+JwnCRv13goVYLO/1CvU4jUGjS17xXesl1AWRJm4vVgpeK1FkX2rBAuUy2
	pozCpLwdY0dT5R/+9lJqKskZ8IRBIBGgFssv/kP6F0pWp3UEIobg52GGSLDC83FRRqCeC4pYIXe
	7PAu9yzjmjRpj+N9lMIaxAgoVsO/pKxtsy9fd3T5tcuTH04l01ka3364xbwhC2Yzr2CuXTV2CCs
	uRPDeDk4v0QKz9hBMkbzSJ9yk4AuCeX8LEMznCjAUIDgeflph1v847Kza8nzhjL7+nfN3+HOD2a
	iHad5IWSe9EF/7bsuGUzfvl5FOUyOW790bU7EoGuOANzoOsUs8qmIRh0vMF4Em0pYXgsSGfD9pD
	AS5FaI=
X-Received: by 2002:a05:622a:11d5:b0:516:dff5:68c4 with SMTP id d75a77b69052e-51c8b403cd3mr96830461cf.7.1783634283862;
        Thu, 09 Jul 2026 14:58:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caaf9a12csm3563591cf.27.2026.07.09.14.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 14:58:03 -0700 (PDT)
Date: Thu, 9 Jul 2026 17:57:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 08/10] dax/kmem: extract hotplug/hotremove helper
 functions
Message-ID: <alAZZzO96_ZltrJV@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-9-gourry@gourry.net>
 <151783f1-c0e4-4c2b-a051-1e6e9c546cae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151783f1-c0e4-4c2b-a051-1e6e9c546cae@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE8D240004
X-Stat-Signature: 9g8i5ubpipdi9nmez6kdmawty413ehid
X-HE-Tag: 1783634284-470833
X-HE-Meta: U2FsdGVkX1+YvofUhKqbZis8kQzjIXby48Yu/u1IfnOOYvl9vwF1OoMQtLXcIjc1eJhwDt/J7m9yeBpDG8W+BrTvR5T4E35vb75R53TWlO2RDjufoFPenPdhtSFk0SdnbO5+5GugfL7J6qOv9ntC0+4SElcAy91R5eY4HuUaVNaHRAlNZhBJG0h2wuZuKM0c5gywnQWeJMiMkeHWfZi+YSTf/h6AoP7OVdHIRoEHMW4GqvGPtO3bMv5jWNId8/eWMB4kYf3Hjvaxpc+1nXmpDj9R1XQvq0pNpx7L8RZUuziKG9SptO3F9rl3PN3Rq2FhanM27zHhw1NLCdMyEVnmma2LKw6A0Y2b+8Qv/J1W5n7Win3q8lcZx/l/4Z0SO56iB1HqyNoDGAKz4xIwRRHDBUAdAkY44RN7Ht6e+B9a/QErayfFUaucALJ0Vju7E+rtYLneRfIdHbEa3aUhqMpYxCEqwMXjL+8hgXkihH1aGjzfiHNZGfgGcgS9kZK9aY04QigauImohIlcWc3HrDZO8JguBhmZGogJ0c3xZzB1pi1IhDecYwFXQMnmyA+RMrLDFNICYNi00A/YW5j8ECPUJvpc52C3gaIjLPYA5RhS4B2mAS9e1Zn61MjR2FFCrS/RzxJ8p9zOW8OIHlIqa71o/YLbdMHG8MIza8LFLGlPfs3hZc1gm+Px9iLxAQlpR+UrYdBMZssj6WJdN0R1N+7PhIXiI+wC9X0ET2xDZSSI8UFuvfscGvj/xMlaj/jOqq04yemExc7BfJlYHlLvUrbXVxsHs7nbpGArtDnVUqLGSFoxfhtY6r8xjoso6eJL+sUNY/1J8n50uC/bHpRVMvi3SMM2VPfjZ/SIkZRiCNeTf9YSaIAZf/m0og835rX+9FWb+YVRHzmstWqSxgYPAt4jexHOZz71YJb1Ye2LNAOgivgDRQpu2UK517z/xLGCCV5Ejte068FQlRf8QFlsUaX
 K3269xwG
 Ra7299Lgk2If/eIiQdz9tyhUsSzxkpsia+ljWRMqP9aVKMy32RmaY6mKZrVhPK0x1bcoXcumYN8MJwNL3X4RubhhKgidiAiqR3fxH9LH3SykcpWE7zU7Jd1A9eVyPTRcK+MikgVPCdvDQi1WRdUVtqwyjhCrUiG8D5ugti6/cGwaESfjcyNeQMunNwXflOo3hfGSLKvYBgBqDWL5ydXyob7xni+Gs+Mz4Jmjkuyu5D0vzAc/jiSj4julYmbj6xxlrYWJlfqfTbhey3LRR0MXvcElgmeUEu3oUZP2cezHsbJ5w4KjlIFravC+xpinT6T1imQ+SnXVq2ld7H5Hf1K8II9AKDhKRLBB/KZi7I7l5ZxiNB3GSrIMWNV6wvKAAfy5K8lwkqOOnWFl8r/niEnITXyIcIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 02:44:25PM -0700, Dave Jiang wrote:
> 
> > +		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
> > +		 * so that add_memory() can add a child resource.  Do not
> > +		 * inherit flags from the parent since it may set new flags
> > +		 * unknown to us that will break add_memory() below.
> 
> 'later' instead of 'below'? Comment reflects previous function flow that is no longer the case.
> 
> DJ
> 

ack. will pick it up on the respin

~Gregory

