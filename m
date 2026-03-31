Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DA510F92EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7546B0099; Tue, 31 Mar 2026 15:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378326B009B; Tue, 31 Mar 2026 15:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B52D6B009D; Tue, 31 Mar 2026 15:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8F66B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:24:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B91D71A03E6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:24:12 +0000 (UTC)
X-FDA: 84607333944.15.954DD13
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id C22A6100007
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:24:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ct4mbDcM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774985050; a=rsa-sha256;
	cv=none;
	b=whj+hbM1ZBkciMS7pn7RPgrwxK6RlYQdp9JRHf1UE0rHeDXFFWm6Gs3cU6xwSj2XG2KD50
	wkVNEeTiS5m2ANfx+iAgjoSbRjazEV6Sa/lIAWFhVIy9C/WpA3+knj42sVjtuj3uel+nNP
	X/pxEj7Q1y0kKV8B9zemSfHN0rbRir0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ct4mbDcM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774985050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/Gc1f2Y7Nm0mkyhY2UGCD7O3dcDvMIyKQbC7AzK6Vw=;
	b=IOJ3MnMfFRbxCmqFz43KR5qO6SbslAGSzftwuqHdNTiCDcxvWxCmjpiEi+XFZKIDmg//+z
	i764TalM6Cbv2XxCFsbK8R1N0rFuIDVF3XlvbMTxItVwQisj6L8Z9mEyJpUWRtEuCbHZFn
	z7j1Vrwtptb9kZrdet2MyAQQASVDk5Y=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d7f09aa39fso7400367a34.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774985049; x=1775589849; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/Gc1f2Y7Nm0mkyhY2UGCD7O3dcDvMIyKQbC7AzK6Vw=;
        b=ct4mbDcMvN7LYDFrPAhVJ/jFIsYISWvZzciiznWFtBQDYh054AbMkpen5tXCy0KkAQ
         900tnuOTOdbvfkrvvwVRnwquP4pMQcaz57ZmSlaX+fbf0vccC3JMl3P3RqH6AZKvBTmm
         quYox67c1xQZLJZAg+3IcSfyY0bDm+V5PxzS8kXTw2BpujAYinAoe59/oaTuopdIkL5V
         1Fj/JQSLv53VXwpnUCNoeGN0mmibutMCGZmBJAzzWacmmp1vaX5jbI7v+Uo1FxQdH8Bo
         OaIXC/ielPGr5ZMueNJpx3pryHE5xr/h1envYk2ziIuxkwpklJxqZXaF8vYoqAOkgov+
         ae1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774985049; x=1775589849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A/Gc1f2Y7Nm0mkyhY2UGCD7O3dcDvMIyKQbC7AzK6Vw=;
        b=ms20VzoCWT82uB5g1TNkRjcd40UXjwG8LxFkXGKKwzHvYkdnO8LL8YutZgIGbIGI6f
         fjt8ytWtFWubSsl+HCpT43gmTB1M0ZsaPRD2LhyvI6m8C1ALNszg0Kx9ifYF0TgJYofi
         nR2YtwXCphUoowCLQOpwRfpwiJWAyIIG/9Ev5mAst4oD3XghOQ2+im/6L2odcUoOyGII
         UEMIbVjH84Xn2pwG5syBpi8qOUOU6pk/DCnPfOqqxJx3VceNsBM5dL/h2AuunY13lNDg
         8bz+QDKlE5AtLBXNq0Dm3nWCSm//YR7Klbl7cslWgFwiAKNF7HwyNauWeoftN/oL2HTp
         ahog==
X-Forwarded-Encrypted: i=1; AJvYcCX8cbUKEQGgPxE+LcANPOFBDwt34j8Jbm4xXdn9R3lBYA+jVxA1H70FC4IN328k15BtGwse0X0bBw==@kvack.org
X-Gm-Message-State: AOJu0YyNE1LCp8aCnI0ujie/l8AJNLIuwX4CpHEjWqXH1MFTwcUw0pmx
	5LMbid0JpC8UFNTKtkyjjyC659ynX/LstlXfS9DQKsg1uC9Qm+y1k95d
X-Gm-Gg: ATEYQzz56a/QX42dxehWx32933gKr/EF99e4MWu287TGBt9v2mPJDVC/QX0UvbtERRV
	BrvVu4iqDF5cmcmtPdGuvZRpxiRl/C018ZVUhFYRyFuPEorf/p+fZ1/OXCyMb7i1wCrtZQfWvfn
	v3H6dav7vF6VTjsBYrRUHkXsUL2A5tdzRN428lUnOKxn2j09YnalVICz2dHJlTvG9Skij9AQk58
	8Oc5oujJnzUz85O3U6Skg5hp/XuhYtzNOLH5WY9zX0zWRPen6eGEoZk1gRHw0AyBsjNqNnlnvb8
	Hm7JQQwqsWQ2Af1CZ8sIKJv3nFe0MD6QYrSXFCp6dMV3y6uhVUHaexLeya+yj7I9GnEmPjyWxTo
	eX2oOCzhPDY6wc4kockCsJcHhzE9qZ2Us9feK1HD03f2NEmqdcxA3pfwaW6lZsAL0XR2GUC5chA
	9RhGKwNrQtuARFUFWGPRhurw==
X-Received: by 2002:a05:6830:349b:b0:7d7:f5d4:ef5b with SMTP id 46e09a7af769-7db991d1434mr655861a34.7.1774985049512;
        Tue, 31 Mar 2026 12:24:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7da0a3b2e37sm9052412a34.10.2026.03.31.12.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 12:24:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Gregory Price <gourry@gourry.net>,
	Jackie Liu <liu.yun@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: fix memory leak in weighted_interleave_auto_store()
Date: Tue, 31 Mar 2026 12:24:05 -0700
Message-ID: <20260331192406.135112-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260331192105.109847-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xziiddg5678qzmnbm4uj1gqfpx3x7jnp
X-Rspamd-Queue-Id: C22A6100007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774985050-234300
X-HE-Meta: U2FsdGVkX18FiVDDN7bZXrasdMM8OIML/Gwu0LVjW6NTpai25Vlo4GoG2BniYAoyEgJBfgi9tQMQ3ZLpm4KCGGBrVzjUTVHBTfOt70LrB761kbrek3iUsTTCgYU2bu70mkqIS8iST3zdTRcAEJSx0eeeVFaHH5ZG3PXnx2eB1RBEM8PICA0UZxVe4GkiXHnCTXUR2Iig+wFsULzY4X9aQ/2j/+S+4pp5q16QqgmDdYewFeDCgIld/5koaRCoMhASoMhlQXJU4jmWu83Ri0OTjFcmKYnNn2nkBpspzkbwgxW8dwFyLATNIMpAun2OyL2tzvGTKggfgHgbq3EGFFFd9eyo+GyyW4cjZACe6QBwWXzRc+jtIe9EKTk9xCuFXTbpcQFHG0WGDCWlJ0vVdi79mb+C/bYPV8dVdUb0vlH78rIj6wkcObAi5qRBeA9uKU/hfAG/83cieZm020f0krIwe4j1OgMY6uXAGVpCoib1YVAXESqBfj/2Pd71WM45qdfZ69QiFyj6gs03qoAM3/O44oIshhZ3ghQ3bPpCoFRhPK7URFJtPu9f3G2W+CynojnksSizrchJxRslRhg3ncfqfYqv2nhchYfaQ3eutkLpuO3OB8SmILMyJpFIWxV1FTlbgPe6sH2S91ewLjoP9RInlL4QUVZvSIGyr35e24eEHu9CYeZwNk3bmMct8Ts7k65B27XCSC7kzE0g+VuLy6eFIzbNTq9ykURg3eIiRCZH/EWea53bFk2jvrPWHO2LH3ElzC+9Kd4Yx0YN+WzfybCPC4i611NJDiOnb411bts58XGumbzm+qfHcA1X23sFclwLFrYJ8sMur9i8lfEgLcp4zt9Iv1YyrJNhCG0+Z4QjA/PhLLjGWQljsfU8v252Qt+GpLAFhftCw1fLu1Lu75ObD/HAmRjmjc+6qvYX83Fa3Hjv3/50BaktQmcNq8+52HyuLgpt1oYKSv7EcIUfS1E
 nRoDv7Mj
 zfOACNNF8aZelkeQRiUhdQf789zG6YLjcR8JCWwo4W9aCAZjsThRk+JQe7y+v3HL1s6wEJ4SNq4Et5nFsWuAzVeMTRY3DrC3+fYWOQzV0yFW+rBEv6FTpp2CWDndM4nqOF+H88aL9ujlVADnSRcEM4TzQypvHJATHe+bvVbvYWDl59pulMbXYX1LV0zYXo4TU+kkCSLOHqr+EB7wjKI1XGr/nsFnnq7BFDCMA9h9ZAHCpQyRmRouX7HibKjkoJZFJCzjWDTzMBiKZW5GYB3LN17fxXLNpQnlO+uzOLRmmoAs5rBmprqR/8olCUWgKhTMnB/yzHn0ITbcPhffPwg8U1qoKLE+c6RQuZHOTwcuyr/Sp9wMotua7F+Kbj3hrsmxd6nPTWhwRLEhSd2Tg6h6jOScI60p6+7EhVyNCwf46w8vXBe42luiwvndEYLQqmjOs/VWfe4f8oNwA01J4F8AHCkpmiZuLk8G17hm0WoOLk2arDsgEp4YfpVODc7saIuaCW9ffojbDOhlTn6HsATZYFmu0YTvPUPtDmm/DjqjFWLzosop+wglG3wKWuQXBCpO703va5TRORiyB3qYRavpl675qPwe/Cgialt8xWt8hE/JIpE6QI+ggpWIvt65shMGe8y5k4YKN5DTrlkN5tJ0P0GvUhfY+WLXzUA1ullMPbA9Cr9i4/HYFEj2j4+XyIC9LqsiQG6b6WNbiQV/2DtX+7cWaPlDpF0GubE2kQWb4YAr3em4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 12:21:04 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Tue, 31 Mar 2026 12:01:10 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 31 Mar 2026 12:53:40 -0400 Gregory Price <gourry@gourry.net> wrote:
> > 
> > > On Tue, Mar 31, 2026 at 06:07:40PM +0800, Jackie Liu wrote:
> > > > From: Jackie Liu <liuyun01@kylinos.cn>
> > > > 
> > > > Add the missing kfree(new_wi_state) when the auto mode is already set
> > > > to the requested value. When a user writes "false" to the auto sysfs
> > > > interface and the current mode is already manual (mode_auto == false),
> > > > the function returns early without freeing new_wi_state allocated at
> > > > the beginning of the function. This can be triggered repeatedly from
> > > > userspace, leaking memory on each write.
> > > > 
> > > > Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> > > > Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> > > 
> > > ..
> > >
> > > > --- a/mm/mempolicy.c
> > > > +++ b/mm/mempolicy.c
> > > > @@ -3713,6 +3713,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
> > > >  			goto update_wi_state;
> > > >  		if (input == old_wi_state->mode_auto) {
> > > >  			mutex_unlock(&wi_state_lock);
> > > > +			kfree(new_wi_state);
> > > >  			return count;
> > > >  		}
> > > >  
> > 
> > Thanks all.
> > 
> > Am I correct in believing that triggering this leak requires elevated
> > privileges?
> 
> Hello Andrew, I hope you are doing well : -)
> 
> Yes indeed, writing to the file requires elevated privileges.
> 
> While going to check this out, however, I noticed a different bug which is
> that the file is no longer called "auto", but called "__auto_type".
> I suspected this was the result of a newly defined macro, and surely...
> commit 6cce897a37dc "compiler_types.h: add "auto" as a macro for "__auto_type""
> seems to have defined auto to always expand out to __auto_type.
> 
> Of course for using the __ATTR(name, permissions, show, store) macro this
> is bad because writing "auto" there no longer works...
> 
> I'll send up a quick fix to just manually write out the name instead.
> Doing a quick grep for the pattern thankfully seems to only point to this.
> I do think it is a bit weird to pass a raw, unquoted string into the macro...

(I just want to clarify that I am not suggesting that 6cce897a37dc was
incorrect. In hindsight, I should have been more wary about using a name
like "auto" when it is already a C keyword)

