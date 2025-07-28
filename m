Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553C4C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 13:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA06C6B0088; Mon, 28 Jul 2025 09:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E782A6B0089; Mon, 28 Jul 2025 09:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5596B008A; Mon, 28 Jul 2025 09:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D07B86B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:00:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 546A7B7CEA
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:00:07 +0000 (UTC)
X-FDA: 83713681254.27.6B224FC
Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com [209.85.208.65])
	by imf02.hostedemail.com (Postfix) with ESMTP id 108418000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:00:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JGlcJYxL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753707605; a=rsa-sha256;
	cv=none;
	b=5bSYr+vQw6fWdCzkEmXWO7hKNZBgXnDbyoDR7yXjQlJFgz+hc8sKW9RHO2kDEsWcz5Mf1f
	OqXAdPz5Cw3NFrQevbQmiOJwwuYXlM1YeQnKxdxH7df3ZKSM51Me92vZCFum8mSuUvN9es
	lTI4C7WpSwI6vZYgfCaBBJVxu9rBW0g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JGlcJYxL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753707605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAfBInPf+dLoIc4ffodTH85AzDFQgemf1hBeYDDssNM=;
	b=v8iPk01fxRWoPncyuZmGunE+/dG6JAZ3rSzVcSjCd6IxCOyks4CaOH9xPEqOOjudA8dXHM
	+U7OWST0OFWvCnVhtNMsl2ZwRy+j95rYpZLOk3sxT/cLJ5LbltvBO+wvIP6Tty2OCziiCM
	tRD+M9BKrHPy8TpGxGnHq4zqnePMXHg=
Received: by mail-ed1-f65.google.com with SMTP id 4fb4d7f45d1cf-612a338aed8so6972686a12.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753707603; x=1754312403; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bAfBInPf+dLoIc4ffodTH85AzDFQgemf1hBeYDDssNM=;
        b=JGlcJYxLYdl+LBII962y1XLHlV9bv50ba3AqC0RcEsna/YiR3vIgbeVms81p/Omg4w
         NJjDaynF9EHzvEI3/d/QwZfrT+iPuLzbFRFivlY5lKk9Yw6HeYDIf1dCMlGKSv/oZ+wc
         uAu6/RQGDkL9/c9O1QB3/CC0nkv43AqAaMt3O5mU6HWKY1YmotIZBEvBmQiAiy9gzRa8
         QdrSUH4XNt4hGxOadDfmk2U3aBEHd9fi/tGbExOrtOLcVRdwQSVUKYBfMTwk9+Io8mPd
         KWWUudbx1N5Ea1hdFc9SqEvz8TBxasTOBmHoHFV+ZPUF8gCLj0EcRMBGMOxsb97EAVM7
         xYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753707603; x=1754312403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAfBInPf+dLoIc4ffodTH85AzDFQgemf1hBeYDDssNM=;
        b=t5z11J0DTj6FtQi1fAROmD4KY5Le4D5nJpc4P4Cp6j7xxk9yZzRuELQ0DCMPLTIyBH
         1XiLjpu42c2XEZTS+cyb09EHZ6y0RKthruQYxgdcOGJjvQN9p+DVtQd6OTZnQk5oh688
         JDpyutQkYA1opd4IaalVAf+d5uCH141pw33erM4k+Eg8MmVKzf2FBlJVBL2xGx0OzZ20
         1yvCy8RPvvRAGC2pIih+LhR+alDQxZoPFOzHJtn7embTiGPIkEXfW1wpkeMSLAyq5duR
         gyanSh6MoS+vWff1fxxEG5zqk9oI5GJGYDSmvAISwfJS9R4h+plKaFqoiGYS4pFnGyEq
         4uYg==
X-Forwarded-Encrypted: i=1; AJvYcCUYGwkvSIXY4+diAWPnzCXjbl+lvUYdzEA/Wtz/27kTUNkoswt2wKEzbXiuuY7hQjcxaRkJME8QgQ==@kvack.org
X-Gm-Message-State: AOJu0YzfpfwqCsfulHDdGuPip20kOpRyiCCRD8iaJUEPAV59CC9YxGsk
	A0OimUjD2NzKL2N7+2vyJ84xxc7zzOEvcOO+STsaySP6MGOHBjudi3NvzQS3fcuygcc=
X-Gm-Gg: ASbGnctMxa1VkQ9PxYEBljyjvcfQuqGnG8s+Y+jfiDT/xfXpFEOG6ewOkMnlzgnsBw1
	3xQJ9Gvy3GQAqD2mHLn3631p8zXDxjYY7bS7Uz83ZE9UQ262q4wVfPsWgz9+m2Aga7TPgexb3As
	cIuWQ4MOVBhUiAq1yxcVC8BwS63S5WykBccGrZsHwa36uoonzqHFFAuHD+OLSa+QWwPfQns2NKw
	k5T7dNdZdZB7SsIhVZMECFja2M5dPWk7m4bxw/IT3ZvA/ofE2gV6vbcfbaExMXIvaAMYnfMCkla
	BUJLamrfSm+drAj2dKhPiI2Gx1L0VCGswnFfg28WqhWineVQbS9HByDijrbX4/Em/AqbvqeySyl
	p2l9f30iz6J2ARAzPUMkLFbqwqHapT24OAcQ=
X-Google-Smtp-Source: AGHT+IG5X28gD574aSfiw70punneJAnRvXl60rca6iHDYvwTxnKefPuCmX5/hlF8rd3WQn9WQZZ/tg==
X-Received: by 2002:a17:907:1c1f:b0:ae6:e1ba:30a with SMTP id a640c23a62f3a-af619f01c1emr1288654666b.54.1753707603345;
        Mon, 28 Jul 2025 06:00:03 -0700 (PDT)
Received: from localhost (109-81-20-172.rct.o2.cz. [109.81.20.172])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-af6358a1aa1sm411374466b.36.2025.07.28.06.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 06:00:02 -0700 (PDT)
Date: Mon, 28 Jul 2025 15:00:02 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aId0UlyH9ErtGDl2@tiehlicka>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <aIdqVNCY-XMNICng@tiehlicka>
 <1f8d924d-3554-43a6-a75e-66a08d1ce7b9@redhat.com>
 <a06922c2-9dad-4449-991c-913fa7765bc2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a06922c2-9dad-4449-991c-913fa7765bc2@redhat.com>
X-Rspamd-Queue-Id: 108418000A
X-Stat-Signature: 11bmxez4c5crsh3ho7pn91uftsen86k1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753707604-907665
X-HE-Meta: U2FsdGVkX19B4sWKrUMS2rUG0jfeKtT9va6Jaqu9WKCHgO8DbbHnjx9YxgWytQYu9qrIRwNrsq8D29YFt9spulfzjf8ChsHOwOZ9ichmJ8KcA2DokUsHqtNqNqhs2IswGiAygbL7aTjiDtpiZ16sftmqx2MRIugTOrlA6GCvGKmfbWNGptGl14lKn50QU6ZRca5G4M9TyQhIV87GTlW8iMj34ggtpbKSx1f/dDdk386Y6jx4NjHqcuZUw03ridjA/xdMVqEx+zaqoeKpMIAqAPI0KdoIPmSgzM8NeD67e/wlWne/Dej6Y8tvaPtGLRBDf96X/x/mXXOrW2nY2po/eLq+OOnb9pdkNmOoJEfwn5+PGWVvHybcR0AEbbdKnQGFs0NCuyKknS2pTVWHZqkQnqQRcuc2WqPWtG2bMzcUY0kX/F3wIS08rd28xlI6Z7tFFuDeH7JoEQ8VTAuArT0lXnPWIHUv3SuXTPjj4LYkEFJjfhThTj2wotBJBzGzW71GBHzCILciXHCdRBB+ROmFuRbOWJxI1DKyPowi405sRC9zqxa5k0BFmDy97V+xd0GAo7BhlTX36Bqyj5n9s3H30upNx79+4XiWoiYecP9iJSS3wpWvYJkudyrIipTvi1mFwY/YITMofsnhmxZNSmvaamRuZwUmB3kWbn/mbMTaqrom9lw191fJIUeTbiWUTFqq8OUo6U9qTTHLaiic5q3q4LD3/cmqM6HMMR8j12cmF63VcOUtnNmDrOAzw6e82OYkbe+XyFE0OL/DamLS98bb7DVbPhboHyA/zPxOYCAB2xlWljXfAi3AicMVVd/2HqeYacvAX/FdpQh0MYve8QPBlu5zjKybz5nPOw882TZfriNMSkUnub0mNT3nuzh6jM09ZgN+fy39NNOc3gkpVVcoW9KShujfcw0ZWn2ddPlLJXMRv+i4WaW15adDatc59i3jhXsRN0gejgbjevR/R4t
 6Y3OmmDn
 EhbycZKY/CHaus34CFkaBPKnNn6vTejdh4Q01pA/SYIhVKvz7nDFnwlP1YmGU11GEM/vsmhVWtOC60TP+DjztC9Ju1buXS6xOiNcDAS4ah1K3NButdwEmDm8PaaLLYICKeGFSXAMEenVQsubyq5nsv7B7d+q9vqOG0fiGbqCoqGY/a/W4b0Cj+Bp477PA3urB9QCciprq0eLagdKBWiJVbpJ/HkemuJbWLtokCEfH7P78soVvfe0KB3j9AUD+4G5lHs0fXfTYA20V5Wc5tv/W+L4y7rU5gaWXf+9d5De0JajD+kFDm4okRlXVCWPZv+c3HR+clT0KeGYwplwhvx/1t2h0e7XbJdQPuBMa+rWzVN+huc2boZ9pwSVLnqfj5sJIXn4R0l7BRCG6s28s/iMU6y9NU8QL4QPoqybsgPL4eJjcvvFgYZt77sIqE4QpVlA/4d5+kmZpLS5eQucJ0XFpL2MJ5cAp5XVZepX3w9eueiUdRFbKD03cCy/BZcPa+jUxUdZLhmfZrnk58UuUJzO5mDiYy04dJzOMCLMr53EdDEIVpCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 28-07-25 14:27:29, David Hildenbrand wrote:
[...]
> > I think the whole libdaxctl handling for onlining memory is based on that.
> > 
> 
> Sorry, forgot to add a pointer:
> 
> https://github.com/pmem/ndctl/blob/main/daxctl/lib/libdaxctl.c

Thanks for the pointer! I will have a look.
-- 
Michal Hocko
SUSE Labs

