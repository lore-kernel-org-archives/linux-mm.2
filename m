Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED99D2FEE7
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 21:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182236B0005; Tue, 27 Jan 2026 16:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12EEF6B0089; Tue, 27 Jan 2026 16:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011676B008A; Tue, 27 Jan 2026 16:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E125B6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:42:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 305E758767
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:42:46 +0000 (UTC)
X-FDA: 84379068732.26.E23F27E
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 672161C0004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:42:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VjA4pjYE;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769550164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5CEx45x1VqBdZR0C8+OcuXcE46R+qBWE0zGdFKjM/s=;
	b=VBtkFJK+9VfIabSolFUqaeak9Hbo7vJjA5w/1o3ypdwzWtdYvvqGbskLpzi3no+87BpdcN
	DB4zYyMx8qW6KiFVrtY/5ByRmBqD/E/pyGIlwnAWuI7J96zYJyxY3yjX2C75ZFnAfrxOss
	xLxctctEMVO8VZBHQJdMyn1I6+mA2VE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VjA4pjYE;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769550164; a=rsa-sha256;
	cv=none;
	b=7FW66RhD1bXbNUdOPZD0gicKKC+IdatX6Ei4j3Rw6eFIUvR9g7egrG8LZWfYqDg/xhI8lQ
	U7mMtw/fzv/TT5c/r4F0b31JowQ1C7rBhKdVXKbQpaZ2FnCcOrR3+Wslaopze/MIqiRSWE
	LEVvHmQfRengZuIGWaunQ4wRnC6YNyc=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c69ffb226eso855385185a.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769550163; x=1770154963; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5CEx45x1VqBdZR0C8+OcuXcE46R+qBWE0zGdFKjM/s=;
        b=VjA4pjYEDg/yDgXAASHHm6Z5IVuZ3XUu7xTSdv7o7C7aFP3SFoKI+BQTi4+kf2alMx
         HR4UQRGfI5rONgJNzNlAjqv1/MVL0x8+gg/3GQsfjwkoTSNwwKjxgESvKXfBfeanwqnx
         RpTnE2YoaFSyKTKanrJL6V8AKn7/FZ0/ZI3A6L1SsT/Y9399KwjseXt1+4SaYW3CjoBd
         cRtHexLeyIhydc4LiXT8rf8ONiy4rrPwtwUkkcbMHaumF0geYMbQbRLAZMMQwELzVBEN
         Izm6pd5jvgIz7U5ToAyBCfNogOm1dFHYMvG/7YExC/GKs0PFvlpgotmq86V7JWPeErUm
         RNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769550163; x=1770154963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M5CEx45x1VqBdZR0C8+OcuXcE46R+qBWE0zGdFKjM/s=;
        b=Kjr/4ap8n1x3ZgAsB7UNKeI75If/iccgK9SzNVh4I/JVWlxbAJJMCuEcvXrVcnw8qy
         ObejqJ8hlorSmRtVEfCxn6rUzdd9jgWT033RDx2mcWRmmagjJDOFrLekZdgfK/+WIKRp
         LY2HWPG5PMX0pBN15fKvWRLBY2rgKT07/uetQM94Kxt9gYp7LPCnD+BShMwOfq+w3rOs
         TSp/tn54lM0VEb+IzNKjWqbnnToazsO+6wnOQN0Ude48SCLPbJUbT1PM5cxkljzJUBi9
         HtVpmq7kRRxNWbD/0+ILq4ESN1qjmKZ7zBXlup1AR3C0lIc38maGIDsWTKqSGz6ditpe
         GvZg==
X-Gm-Message-State: AOJu0YzBI4TlR+qQ0NFXAyvsOCsRbETwF5VzN8dC1eTXwW+lFId47I5/
	gk8cwajr47NHjv4F2tpdDTJKXj3Vygy5RcnzTHSFSn4xBgtDAtoC3tt9/uRjv2h9Hw0=
X-Gm-Gg: AZuq6aLwFBnsQB2/89lyunb9dIK/2zXzRWxVZo7j4+Pnf7PBUKh2DfTSmCnd4GL7Vbi
	zezHsLkpR+4iTCefOLwAIcJqNeLdwkVAOj8qHi8TNXDggEOVSIE/HaA3HpxePmaT9lD0SqYXzVd
	HkhZxrcVa0/Su6L4q+PU/dx6ztV6ZpGi1jjCMQ/zM9X0pHJpSHTSaJOx2EsG9m2kyQmuvvHXqEy
	1y5dorVYgPJztVzjoESXAVqIPe4zfZ9SojO7sOEmzHQ1FGVh1dpyZGH5jYvy54Pm2mgF05WrHwY
	OhufHUAToeDxOjF+WMJjC/dCn6Q+jlM7jW5gMtcSORO121fwBbOi9TFmvnfTSMYqM/pjVA9CaDO
	/0/xAiyXOXWYCYQlQ6cHl0X0pTwn6dyBmnO7FqD5JvI5aVVGXZRsUMRXFXOkVyZSKpup3ALBdLg
	1j/5XmNp0j6l3I8+Lexme6BwbQwGMaZvz1aYR/k9b5bpfA9FdGApicBTV0YsxUyx0fTw+94A==
X-Received: by 2002:a05:620a:46a8:b0:8c7:1317:142e with SMTP id af79cd13be357-8c713171495mr79844685a.85.1769550163585;
        Tue, 27 Jan 2026 13:42:43 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711b99fcbsm56868585a.18.2026.01.27.13.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 13:42:43 -0800 (PST)
Date: Tue, 27 Jan 2026 16:42:41 -0500
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, david@kernel.org,
	mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de
Subject: Re: [PATCH] dax/kmem: add build config for protected dax memory
 blocks
Message-ID: <aXkxUR2By_GQ9Qqn@gourry-fedora-PF4VCD3F>
References: <20260114235022.3437787-6-gourry@gourry.net>
 <20260115024222.3486455-1-gourry@gourry.net>
 <20260127133431.671e4605eee807abe84f92f4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127133431.671e4605eee807abe84f92f4@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 672161C0004
X-Stat-Signature: tqdbsnojtm4wb85ubqxtgwnir6qskmta
X-Rspam-User: 
X-HE-Tag: 1769550164-449225
X-HE-Meta: U2FsdGVkX1/pJaTUtCWizmzBmxI2zG0sfokoKOuLA1Q4WUGvjeI9+UrngzMHwqKyXEedv7qDTwRv+gQEHfuq6gtSpxP1ky0Hl3KDRTB8URK131tXjRrU8ur44NA97fKk9zsPjz7pr0Dqc0CR15dBM3bztz2KVM5MJ0UeJIhAMvtUIVEKbL+Mu9wlphG2BERbryIPMREuBs+tAY/WHyxVJXOmJ9QfVc/ZaZraiyoeZ5suxnlV+tM9VpSZDEVyF/tpjXmXeFgNgHEybLKEBd4dUD/8tAT2WKaPGDnpYx2Yk1ChAlpPUVhF8qs4KhvGAO4QVSDZHuiPXkM3w8mLc4ahGEXrj1qERSbNOCvqyD8Mzhy213GcQjZkr9vw2khB9zqtrnnQouNqVwhNCpUJZ/ESdKFI4FjlMXJf5F2r1fPLGSXA5vsVAxaDX5fyR6H5OTvdWORQRSOovl/o9JZalYhd+9pxCMK5JwKjJqmqzDZ64uDstmQHxG5JFEKz5jzJ/xARxEIcn6v9rjqXmnTAaPNuzhn+q21Z56OnGJqW9M0Lrct3uceoOVRsmb9WTd93MNrX0YME0+Tw4nUMsqXAbofWh4mZIDSkDEEorLad9Lsng5zWorHH/DS6hCS3eoE9qzXOs9nN5R/X5L0eZ90hphXDLNaT+TN++RjJ/4ayuzPXIF4LZqMjRi+0c+sh8AJ9ZktZnmq9BmzkqQXbiBPutTzH/7irdu5Tvkrt6kFM6FBm79h095fu7LqGC+kURleO2DZ44SZDe6bFhTzayLC2g2UTkHOQXi8ADPv3rB8dMP+iJRYyrrszVXBZ5AibssCMrKc9yMwLs5cRv4a3VGbPUmMSTWyJN8Zlsr60fu7fQ4pb11YVxjf3zk7btIwaiyV+ch8m6UFl9pdw7emD4dYsnuAdSm5nCVwfH+pifr2079kBuALJkHKIAsmSkQCXg2uc0qJku9d/o5KrTzfjvQGKAu5
 cAfzy8oN
 Lnp7PprhIi1YBoZiEmCNY9IwAmpDOOVztXLznmsMSZIF8impZy0DUKWWU75fZ0cEaVzEd6JRos09rmgfr+LonH2jMbkq2BXAsTJwgcBjHne8WwwqGXQ7rXn3OGp73XbF11SqFMHtjUD5+pAwf+Zc9XvwiPdCAA3ATF0RNmj2cmNEJI2vT8XDWS6rpk3B+aD2GzD+Tn437H65IDMRGaVczfzB+P1VBg2VCq6QGAMStr/4S7pj1DcaDtsHcgTnxRZdBH+dzdS+d/bTgQHjaOGStH48KgVSyH8Aa3iYJRcZb35Vx3NdU6yBcJXepNCyWZar9xO3BRhwfRohF82bHHW4pvPoVc9+fqGBzIbG9TAkzaxsqSYKNTNhKGCYMq5fmQjcZHK3g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 01:34:31PM -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2026 21:42:22 -0500 Gregory Price <gourry@gourry.net> wrote:
> 
> > Since this protection may break userspace tools, it should
> > be an opt-in until those tools have time to update to the
> > new daxN.M/hotplug interface instead of memory blocks.
> > 
> > --- a/drivers/dax/Kconfig
> > +++ b/drivers/dax/Kconfig
> > @@ -78,4 +78,22 @@ config DEV_DAX_KMEM
> >  
> >  	  Say N if unsure.
> >  
> > +config DEV_DAX_KMEM_PROTECTED
> 
> Users must rebuild and redeploy kernels after having updated a
> userspace tool.  They won't thank us for this ;)
> 
> Isn't there something we can do to make this feature
> backward-compatible?
>

This feature is likely getting dropped in favor of pushing such policy
to a driver if it cares that much to prevent users toggling memory
blocks.  

I will likely re-spin this series in a week or so when other non-mm
changes flesh out a little clearer.  This will be removed and some
of the mm/memory-hotplug.c changes will be changed to prevent the
modification of an already extern'd function.

~Gregory

