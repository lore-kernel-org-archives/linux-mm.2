Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DD6CC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E924B6B0088; Wed,  5 Aug 2026 02:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E437E6B0092; Wed,  5 Aug 2026 02:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32066B0093; Wed,  5 Aug 2026 02:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9DFD6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:05:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4044160379
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:05:01 +0000 (UTC)
X-FDA: 85066177602.24.A2C6D58
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id C7C05C0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:04:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BkHnq7kx;
	spf=pass (imf28.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785909899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSMqYBzIGEd+bEQZKAp6F83EI/D8TARVrS07DYO5Xqo=;
	b=u5pQCm+bw3FhcMN6wRgpaT65EMIU2UpQDpA5yX6gQMezxf6S19LeeQ5XqaLz7xVsDWd1Uq
	OOTlhmsC7okACnNb9enaCCK3QBm8E8WYQIxIs5CRcoUHPHu2rXWKIozG3Refe8t4wpBwXX
	hsXUML5aUc7SymmzGgIJwfcxqqIDwt0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785909899;
	b=K1Jb3HYNcT4T7FeKxC9kOxT8kl7AvcY14gm8a+WMv+Ci0EOfKX3zaCSiJ+ykovmNxTfj4x
	8dAYiDVxIgRljJccExXI6XpE8SqlcVfnC3ClW1UrpTvbGBMBXGyZzFJ+w+DYuquGXBy6ES
	fHfLMnOFUVkKgA1WhzCAXx94+2yjoco=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BkHnq7kx;
	spf=pass (imf28.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ccdf36f63dso84665ad.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 23:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785909899; x=1786514699; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VSMqYBzIGEd+bEQZKAp6F83EI/D8TARVrS07DYO5Xqo=;
        b=BkHnq7kxBQStSK+vuWUdxvuemyWUV/QiqNijvJcdeKOvlfdsQyj/+T2E8yEGJ2T3qF
         MW7sdHL0GDVQ1pD0iwW5XvcpSJzwBK+V96VHHnHow/scFJEtKRXwILghdipNRnfwa+Mk
         vd5QNRYOnf+leg3sIZzjGnj2vspCWFJyPtc3/wHihJ20R6SaCYBHkPfLzf6xFECF3KEa
         8hi8Pwiy323hmpYBdDk5WlMfAM5SQd+mqUQZBwfui0+utIklQ4Ntp+fECc2JwkV8es0E
         d2VznC4qK+A95UfcvSyZWv+By5mBL9iOdK/sAnKgndjTzys5BKYVbACD9wDY5ydt/av4
         OMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785909899; x=1786514699;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VSMqYBzIGEd+bEQZKAp6F83EI/D8TARVrS07DYO5Xqo=;
        b=AlvuwhvhJhsSDsaiKR0hizLTN6nZV35WAP7XRFnju9CJdNIg4u2YAcgQMe5mX4QCsn
         ms3vcShPRJcZ26OuQwlzTDlUAA0RNpLEDi4+CPY9MHG4nYjLuqY2gqOvH4QabjhupUZc
         wNvOl3evtgpuMIy5Ase3alB6btIg/dXMTB8fzjpKs9ihEoQnzNccrhYocxo0YM2MkHqn
         p82J4Wg5UZPYuRD7d6DuKVpORxzDowx6eAmx4UIsOoopHnomvn1Mt2NuNGIoeeI6UtoK
         DN45BVlfAac85kpTd5ht+bpVrGlbnEkttGCTd7Qtw0MhuLrIArrPcZsKSF0hWgu0/vz6
         lYhw==
X-Forwarded-Encrypted: i=1; AHgh+Rr50iTtj0rbTr1sXbbjVju3q4Lr/gGNQSlq/cjQ/hO9G/hSXvmCxBeWv76SR7HEV3bCgoExOEOMOQ==@kvack.org
X-Gm-Message-State: AOJu0YwjFxvFqeNFaADY0r6O5m7SLGBzz1JxeuDVREZERA6dyOMfct6S
	eMV6XyS5SMxlWFSwem6YMa6cVwpRBBTcqEBNDt6ohuD+onIH/p364F5rYUsMuAprww==
X-Gm-Gg: AR+sD11Py4cwq9XioLQE8kKx2+8S03wal9+X3bcZ4t5raJW1PWqBHFf8tX/Q1rqIPsg
	v5zbp8p8k8Pn5RkUWNdHvE99m1/jDJc90QlA2SWp7IFx7UD6ency+Sw6Mq6zwQ8FZod+9UEzaFK
	ms955xSJkzA66536NLEnbBwL3HEuUYwZQ93cfjxMWXVn3UQUUWXOqbD6e7sMl5pPxUjSEtkikzz
	raTJL2EVT+8z3iEkxNTXeyQ5/R4yCPAIn9wIkFo1RpaE2ul2XE785XfLRYRMXZvxd0SsOTLnn/2
	TYD9OxP2d4MLGViOpm7lgrk6YbLLHnL92bP9Pt/TLsV60YiERFN/dDOFAqbCSb+jNOg51HTThNe
	bp79cLSHMWMlwObhZ+3ZyVZkDyGqSjv2CYr0+qb/fe1xOFC3CWi4hZTEaiTDD3wzFdSXwwaBCGp
	X4a/CemLFxOrVspp0onJpzPuVDxBvGmnoMhtm9bnFWZCUZcAqIUnZCtBUtL/Ad/DTPwKk6ZyDt1
	nyvRcM9mmduBR4XgX7MhLlaEA==
X-Received: by 2002:a17:902:da89:b0:2ca:6bf:5bac with SMTP id d9443c01a7336-2d0cae8f44amr8339885ad.8.1785909897932;
        Tue, 04 Aug 2026 23:04:57 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe707cab37sm740464a12.7.2026.08.04.23.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 23:04:57 -0700 (PDT)
Date: Tue, 4 Aug 2026 23:04:53 -0700
From: Vipin Sharma <vipinsh@google.com>
To: alex@shazbot.org, rppt@kernel.org, pasha.tatashin@soleen.com, 
	pratyush@kernel.org
Cc: ajayachandra@nvidia.com, amastro@fb.com, ankita@nvidia.com, 
	apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, 
	corbet@lwn.net, dmatlack@google.com, graf@amazon.com, 
	jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com, 
	julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, 
	leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com, 
	parav@nvidia.com, praan@google.com, rananta@google.com, rientjes@google.com, 
	rodrigo.vivi@intel.com, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 00/20] vfio/pci: Base Live Update support for VFIO
Message-ID: <20260805060336.GB806762.vipinsh@google.com>
References: <20260714151505.3466855-1-vipinsh@google.com>
 <20260723215749.GC260824.vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723215749.GC260824.vipinsh@google.com>
X-Rspamd-Queue-Id: C7C05C0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fx443dtdo6188r5shxrrzquzeknrqfrg
X-HE-Tag: 1785909899-748307
X-HE-Meta: U2FsdGVkX1+EDqqX+yJkovL9O8djhpTP0J3ZSLwYyyn3visr+lOOVEEJnC1tYnzmvxXbu/PedSGeD9XL6u8jPLx+cTTHPURz0XTCLFhgEn5+7ikzZaxE9AHjwThitc66Lz5qrnC5ibWU6IKPfIhWUaop2xG3q6qv8Gs+zq+KQz9QNPVKt8SAtcOHNlEuDRVZygHXk0JeA0z2hUUf3oVOXKzPYs6Ci/a6fwTDsle7WEpP3iRFpNKFAcaeA60kjizLrOTHu6RhNr0+0Bn7S4Vu7/WowoV0GZKqOrQhGneqo0s65sQ8k1t2IgoCTAa8eg0REzVoFXVDeL5adh2KjXfFBpnUR7iJeoxtTZ8nTVMX1OEqhTIlhAYLSiiVlXON/hdy0yPtThVee0bhjygkf0XnhAxkFx7UC8hC23iz45JFfOEFAaXK3NuWn/5Z08Nx09t3GQGBpVl3xf4d+1UHzwZMWoc2h+WTX57huuFyrW6fkDERbdiAxru5YbNXpbYs2O8EXISOBEo2kgmeWcqVLOfoINyOsLUtPlNgObmEmVCtKwcFb0prL+e8vt3vm4E1ymT3XGP1M5pY6DIIZ+JqaKqyoWI3A/asUAo75+jg8sFcQu1OW9eDKRL0Q64PvEFXf1ZigQehvwRP+wm2zyVsOf9MG4BdDFqR4i4MKyUsYIVpUp/2jlHLfxdrG3EaI3owNNgpo2BbkGpCUTza9c8l8On+qZAXggf8e8QHdubjUP4GT/yM/KJ/bOfbmW8nRL/u+46ogFz4qQ53i8nhoGI6/DiVII0XfsKqxD1s56azVRegYLvJSSncFqQfelTb2ZLkVhUZ1pasIYalUuchS5kPN6awhL7sKTrdrI30WUkomlaXkL9GuluYqjXNNOyGUVN8hTNOE7YZyDriDlbVK2Yhl9ywC2fEdt077rayy4HFSf/Cb9aRw7/Gzk+MxFDzgdEXZxxMVY61JnACLwVRBm07Rx9
 klBrPykP
 9LpykQo5GQQbAVuUn7HzCt9VvCpNUkKNGRDM+lTEA3v5V87Cs+Cmogl1FvV0T7RD07Db9q1FuE3d4QZRQ+5tDtrwiFMZeAM6qTeUDIYP+4b069qHOWRJMD+RFl7a+C9rlnZwwQtqdwenI+fRFy9exxEZSoPjWhx67zFX89ZJuCx7LfHKGdLZfN5i4ciFfESMCAf/R8O4bMjSkc4YzjQcORXp18vQ0WYiMhGOcPbvcGVdIooSX+v30qI3vZ0IC+ZHfTXd5ZcuszUSgQ4XwybHYggQcmNZcVGaox4ME48iV1uzVt/VUYAN5sN9jUka9AVWznHDxZun+KWuQyZ4B3b+zToaxhqFFDGz/nH4gb0r9COmU4IBOhK5GVbBSPgcV0qEFIDVYnw7/V8eWGtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 03:58:45PM -0700, Vipin Sharma wrote:
> On Tue, Jul 14, 2026 at 08:14:45AM -0700, Vipin Sharma wrote:
> > Hello,
> > 
> > This series can be found on Github:
> > 
> >   https://github.com/shvipin/linux vfio/liveupdate/v5
> > 
> > This series provides the base support to enable Live Update feature for
> > VFIO PCI devices using the Live Update Orchestrator (LUO) and Kexec
> > Handover (KHO).
> > 
> 
> Hi Alex, Pasha, Mike, and Pratyush,
> 
> I'd like to discuss which maintainer tree should take the VFIO Live
> Update series.
> 
> For context on related efforts:
> 
>   - PCI Live Update is targeting the Live Update tree (maintained by
>     Pasha, Mike, and Pratyush, with David Matlack maintaining the
>     PCI-specific code).
>     https://lore.kernel.org/linux-pci/20260710212616.1351130-2-dmatlack@google.com/
> 
>   - IOMMU Live Update is planned to go through the IOMMU tree.
>     https://lore.kernel.org/linux-iommu/20260614233728.2212104-3-skhawaja@google.com/
> 
> Given these different approaches, what is your preference for routing
> the VFIO Live Update code?
> 

Hi Alex,

Gentle ping. 

Thanks
Vipin

