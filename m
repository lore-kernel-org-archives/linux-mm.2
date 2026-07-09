Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A6F8C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 23:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8F46B00A5; Thu,  9 Jul 2026 19:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352826B00A6; Thu,  9 Jul 2026 19:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DA36B00A7; Thu,  9 Jul 2026 19:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAABD6B00A5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:06:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6589C120305
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:06:46 +0000 (UTC)
X-FDA: 84970774812.17.2B2BB82
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9506A140002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:06:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="u/bfFLt1";
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783638404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+I1Kh+neFzTKmOmQym2AfGZpWjdwKJKu5WX9LjuS6A=;
	b=HVbmhZQcEaBZlZUqKYtdeTFhXkVVqQXVjicLZqJD69rFfFQY9ytwguGC/W9dcp5WnGOUWg
	TcQst9iDG8kshKcciJ+x7gaAwMhQs+LsVYK4N8Tmup45LCtHuV9wAG1JqO16CuYqyCxR8Z
	xl/gYm7H2DSsyZ4vmiOIqTaKY/N6TR4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="u/bfFLt1";
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783638404;
	b=JN3nIRpowDcssVa8ZyKQx85qdWCX2FzN/3CfUrbEuxcYaLg/ixPosWcr12sfx2tWdUOOfs
	/Jc8c9M8imbrgnlul5jl8IoNnoE0YD+T8wiMTggL6glNhg7Mm/NP6E0M1aYkr8qK1p2Hnw
	RWATGGdtt4lW9SfCcteRtMq4235Sd3Q=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e50979c71so25226985a.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 16:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783638404; x=1784243204; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G+I1Kh+neFzTKmOmQym2AfGZpWjdwKJKu5WX9LjuS6A=;
        b=u/bfFLt1Lkgg/uWWtVkHMM4NxnSM0wduahBK78iqm0NgkTLL/1jo4t3htbxjjgR34P
         VT6T1urHDgPO2JL63OUEkMHXz8suMN3mXl4TTOcE3zae0nWWsoaIWH7IIPccL9JaRwyS
         3HizmSu7uXfgBwdgIet+wXYmGIox1bcaRKGUv5SNXdlj6i2fO/bw+Vj4/4M0P17jObSD
         YjRTrXuWl7SRIMlRTOGqMCTXOwdddkhG9k2GRrG5pnB4jOGs/ifxEjZ2Bh+9vZo/dxIm
         u2Y/0p+gpl6hlBQ+dVPugKPl471TIg5yTMgeOI24mqTvMEuzV8XEIVHGTpAxOzd0hQOb
         1Ljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783638404; x=1784243204;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G+I1Kh+neFzTKmOmQym2AfGZpWjdwKJKu5WX9LjuS6A=;
        b=iEqO3m+v/5ull21vE2LED41XfwiQlpTqsAx1L9dV+VWTfmdlQ39O5zlkn+bEQPUiIp
         RWT/+cYZtvsc31nE1Tf+DtPsSIH1c3HusJv9xxa1Zt8oLmaIEPWhWQ8mxxkeNfdAAAiz
         1gh6G3Nkq7WZ64PPVfc6yhfDmOwFTHc5bHRFODIUjQXj3ftVMzm+it0RL5tWU1NZ8G2C
         +qVXxfQNIP8IzRoTnO0Y5I6EwbAcr9SLgjlcbafW+6n62vtg3QBWH0VoYb5Mrs/HhZLe
         793GAgfGUTaZvgArPRxqorxOjvol1JnzYkBpjMJsEUvBlhLZfggO8WpZQ1IY9MPwSX/t
         15nw==
X-Gm-Message-State: AOJu0YzqmJwuSkvRjlz1p/kS6MHvj9lkKDqWM9cn6FWRtCpk8DBCmR84
	l8N9sh4WNLbobjfWMEH8sRjTk5dP/IvxrHMsOECkEqiK7OgSOpvykV3vam9CpNzqLBs=
X-Gm-Gg: AfdE7ckj/VM6i2iS5knn9Gau0oU0R2wPYgOxapzbhpOx/r73IGqomVG+yjknyDrZztU
	6bb/99t2P1vpakVWJZBVEl5sE8tXEeFLOKcqSwA7jMZyYxZSeU3jhLyAA2h2919Nwj2JHlh3uBO
	FgPpGxctm+sLIEbGX5WWvKct7KNicfM6cYV/ukk6k2l6DD974/Xxg0jLRFLHqNN3s2gprKxx8bH
	FGzRZatpslj65wtP+9d0b+3qa4xLWiWsZIx6Hwl/L1JucSXZlL9Flf3j+VSzSHlAaEkmlJs0jRm
	YedtggYRy99At5NbZjZZnDUhVPS3T/ripBWX1lDSrANfC8Py5Z+8Bj4x+9kFjdGICkBGki5eONl
	lIunu6uJvYaGc48kShtZcXLuwcVkxMrbbuMlHsFLbklziAtypzzvgmSIAPubgYSTJfWNvAkRZTT
	8EpD2DyPSWInJyP+1/aGNwgUJ42ngV8OGSpA6agf4w4by6qPL5ePoT8Aw7cKiesDNOZGoP
X-Received: by 2002:a05:620a:31aa:b0:92e:7db8:1e86 with SMTP id af79cd13be357-92ecf6aa487mr1099339185a.58.1783638403562;
        Thu, 09 Jul 2026 16:06:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b4b1bbsm59189185a.2.2026.07.09.16.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 16:06:42 -0700 (PDT)
Date: Thu, 9 Jul 2026 19:06:38 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <6a502267b17cc_3b7ee51008f@djbw-dev.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a502267b17cc_3b7ee51008f@djbw-dev.notmuch>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9506A140002
X-Stat-Signature: xkwukborpnxpeje99x75dxpw58jcqpyz
X-HE-Tag: 1783638404-595937
X-HE-Meta: U2FsdGVkX1/ujK1mpdfVP3Aj5zaHA7v61OBE4gZn6GtDTOcqcW7RxtqgigxTIBhcFlpTI3nwBH24vUNljlfhvDYY7/jhyEjZFO8oxvv9J+tOV1ss8wV2GuSFsBlzjScrdsgmBIvfpBhvi/75Nm5gSSAqdnnUnu/Zv6JipSITmZWI/fx4Xv3SPEwZ9Wo/Efp2q35PJNzJr8VV/AwJiracD8Pqw/YsO/BiNWaccDHNkpqdcXR9rdyHC6EDkcTkNAgzhW3jZ2MeaJueFb29rkCI6hpYKLUja+zqa0CeSovlAJfjFSVvyMuwJffAOtSGI+Mf6ai4ndUxhKuLEgYCW6VgzV8Mz5xTpQ1ir36J42b+sOKJ3rCrkUD7YV/SnSaVZfgT30eH5Cmx0wXGpQSw/iutYrcOpGElT8dKL9cxgABXKSnN7WWIZxaJZa39kRxMnpoB7iL0gf18TM/BwiXkjeFynnsMrdUJ/GdmF504I1UJS80fYHxFF4OqRfvHrUcalr8dGph2H+RX9F+9U9bfOaLRxOzoT9b5UofqMG2GUoG4db4JLv71g+sx1s8G9feT1wJjTnNCkdqPBpoyMPP3U3dcb9oUe1C+MmhNbuqziFikgUmzBhsotyUU8GITdP1MaiZAmNFQq8DzVyKsyhIhD7Q2Rw8tvFald+YuLnC+jRDICmS4RwNfRshMjuZBOXAx6g9dn0QS4oMP7hFJFEjlmee07rGEGNFI8wpEPtHOGBG+C2MWWW9+SNdokTDyfEZN1+kdqY2GfmZjLBcq3kEVDxko3ZJAVlZiBWwu3CBiJiY825W9ktmg74wnXUjC21VuYKU9y4AA3n8Gx6rDxnCTgvh+rGUa/I9wRgMF8GJk9EJ6t8vvxNbyjkKJ2fe8IB7o6/TqUoDKeZrx76kgUfc0agpbC0Ovp1EhuWIAsExkulleWh4S5D2bEVFOhz/W2rNl+SZ7e0/ryRPMfVXAIvzHUHT
 x3d/3i9Y
 urGq2Rs1x/a57+kp/iWmbL71/UMPvs0TKx3kzoEq7ffEl4HcKVSGuUBpizSZzL89+SoHzQJfSBH7rVFkHo01lu3t7DUlbOR+UWS1BT3tTce4GVGCS4wF6mJL4D88EpJp08eztignPLvBCA+6BubWi9WCCoYM1FEH9luBaRqr0gX1+cz1P2fAx02dNfFkyCv8mD8M3QFw42quBPshKdl17fyYcDQ+TSc+IOAiSXEbJMysLcc10tVoLEZ3m/9z+bGKfIw2tDdUVEPLP9YwU4Dw6j5gHIG7aFhzVcdH/Lfn/zhVJLU53ydJxWdaRZpxv53gemPEG2Z6lyhwUHrSIj5TzIS10t/qh+9vbT68Qdjeej5P4La1FeTqI4VwY1/EQCbZPuihnMsRL+Qbl6ss0tIawih88UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 03:36:23PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > +	ranges = kmalloc_array(dev_dax->nr_range, sizeof(*ranges), GFP_KERNEL);
> 
> The new hotness is:
> 
> ranges = kmalloc_objs(*ranges, dev_dax->nr_range);
> 

ack.

> > +static ssize_t state_show(struct device *dev,
> > +			    struct device_attribute *attr, char *buf)
> > +{
> > +	struct dax_kmem_data *data = dev_get_drvdata(dev);
> > +	const char *state_str;
> > +
> > +	if (!data)
> > +		return -ENXIO;
> 
> Cannot happen with a dev_group attribute. If probe succeeds then drvdata
> is present. If probe fails, attribute never appears.
> 
> When unplugging, dev_groups are unregistered before drvdata is cleared.
> 

Ah good to know.  I am always paranoid, but i'll drop.

> > +
> > +	if (data->state == DAX_KMEM_UNPLUGGED)
> > +		state_str = "unplugged";
> > +	else
> > +		state_str = mhp_online_type_to_str(data->state);
> > +
> > +	return sysfs_emit(buf, "%s\n", state_str ?: "unknown");
> 
> So the "unknown" case does not need to be here.
>

mhp_online_type_to_str can technically return NULL, seems better to not
just let a NULL dereference sit latent even if we can visually tell it
can't happen today?

> > +	/* Always create blocks for backward compatibility, even if offline */
> 
> Unless maybe a driver knows better and wants to preclude the possibility
> of legacy per-block hotplug policy firing? I.e. driver asks for dax_kmem
> to start in the unplugged mode per my "should DAX_KMEM_UNPLUGGED be a
> online_type with a different sentinel".
> 

I suppose I can put DAX_KMEM_UNPLUGGED in the header and allow this.
That seems reasonable, and makes sense why to differentiate
DEFAULT/UNPLUGGED.

ack.

> > +	rc = device_create_file(dev, &dev_attr_state);
> > +	if (rc)
> > +		dev_warn(dev, "failed to create state sysfs entry\n");
> 
> Always prefer statically declared attributes. In this case an attribute
> that only appears while the driver is attached would be something like:
> 

ack.

> > -	success = dax_kmem_do_hotremove(dev_dax, data);
> > -	if (success < dev_dax->nr_range) {
> > -		dev_err(dev, "Hotplug regions stuck online until reboot\n");
> > +	if (dax_kmem_state_is_online(data->state)) {
> > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> 
> I like that the BUG() is avoided, but I think these should stay
> dev_err() given the severity.
> 

I had to go back to calling remove_memory() by default given different
feedback, but I think if anything I will just modify the BUG() to a
WARN() and call it a day.

ack on dev_err().

> > +	struct device *dev = &dev_dax->dev;
> > +
> > +	device_remove_file(dev, &dev_attr_state);
> > +
> 
> One less cleanup to do if the attribute is registered statically.
> Attributes are shutdown prior to this point.
> 

ack.

~Gregory

