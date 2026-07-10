Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80CD0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE8C6B0092; Thu,  9 Jul 2026 23:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FBA6B0093; Thu,  9 Jul 2026 23:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361456B0095; Thu,  9 Jul 2026 23:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF3C6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:18:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F215A120361
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:08:57 +0000 (UTC)
X-FDA: 84971385114.12.9562C61
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3210540002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:08:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OAMRwcVp;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783652936;
	b=Qs2S3q8n6vgj3v8txCX/ekuyn4upqq7RLNgJsjn96MHh4X6YoQ8z0pis5Abaw5PoITuVUG
	1iUPuLH7p8AVg4fkya8L248ZdulZokV3GmIH2Kmg64OjYS9m47DNnqptuAGHxLJaEjx7C7
	sHwOQ7DOrX3lK6p60QyyL9ZaDVtmKg8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OAMRwcVp;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783652936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kr6wGBD9MJbLbiRkKQ9M+EqleUNYFT/q4nJmIpqWguM=;
	b=FkUeKVd1HPPZd8PUtkTJ2cwUOmbxP6tl2kSC5QR2t+eiVSU4xqFNpiDBhmSmAE3C6JXMYt
	5V/j6gFIxgxBnY0MIpoMsyDCibGHODHGx5QMwg6YBXTrtoLIlCYgj85NFGucr6OwVqtSsS
	3r1eOb+nGKe2UjwJ4uM5a8sWabHlD5A=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e5b048375so19251885a.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 20:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783652935; x=1784257735; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kr6wGBD9MJbLbiRkKQ9M+EqleUNYFT/q4nJmIpqWguM=;
        b=OAMRwcVpN93WZMO2R+WwqOHw34O5MM4ofeWmz7QUFgbAigC4PjXWKwmfNcR5ba7l2o
         1CUFf7umdDAbq9sSIzyeeSlcJH2r7FHzCY/IgT8j/QclPd58JQ9tmGnLl2dTpJJIyDBG
         +mgQ+WMHj6Os6fK9Vq9ft7QM0AjbVkLAn63LutB5byiBpxl2anOhVb/mspUCX9m8S/mq
         oCPxjy8MgRqjAMJVIVgW9RvMRxw8lxFYLiCCw3Z+jY+g+Q80zEM2zLFqrGRKfqCp+CgO
         0UfKqMW7PZKRq/C3WYxF02iE42yUFBkqbuoPCXm/BBO16WBKgdZgidH4Qq5NB9TwJsKw
         VBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783652935; x=1784257735;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kr6wGBD9MJbLbiRkKQ9M+EqleUNYFT/q4nJmIpqWguM=;
        b=gc4c5Tv7wqe0vBu9TRIveWaKJucMtmwd/PITeczSyZh4X6kAMh1wXD9uPi+tKbRO5R
         /JxoM+Fj9604E960wLQJKqyB/LH/0PXnWSGNmU86oIxl9u/DjB/JIv7gE8GxOJSwr7xt
         8WT6eOTDJk5yzDZU0LWz77C/PhZxxu/nA+8eKYI55+RqBjHYNM9s/QYQ/tjWB7h2fcFf
         FiWcP1njvvhTbO8FcsakKJlGmjlDut48vNvK9BaYjPxSl2mqv1SfcTFk2mTRfxaLxVxe
         jCl+9TFr99u/z13HeqlQful4+wLG86Wdev8ff9hh5U94pzKi2iWlsKuSqN+pNjqG7OI2
         gY7A==
X-Gm-Message-State: AOJu0Yy+ktweTnm8LYiS7+DPIThh3sei+2pEcdipr4glqw7FOmvvy5JJ
	8KX8nn9WvZsnwMfN4Yki4FBhSS85NL+5V/hoOZk13Z1h17Z9A3nLEMoMD+vsi8Kh5oM=
X-Gm-Gg: AfdE7cmKfzknLBS7lYDZrRvj1o1fM2tv7r4DOB/7uMzpM1qXRe8Xq7F0lQ/d1CrEswP
	HqpwRiIPV74nWHYINnah3BppG4hVnU7pL9dtLSyZ0Fgnu91ApLBAxQ5yjE4l/6K+oh4YoPMwBKU
	6on7pjX/KhPYYR/QOvaztWbUIzro6E+EpOkcjrNeI5dfZXYOYp0q9/Zd0wnREmAkg+cHwr6C7Tu
	HsXoQUp/TRuhNjAGNG853CHHjqGVqru63qMS+gEgJItx1tGPShc/CsGr2FVhJgJ/VxK9tLpi2li
	m4yh9o1irb1DAWyUVE8Pe/KDRWeMTd7A7dy8gQjOfTe9JvqhCKi3wTsM0SGrIYefjvuHGD9fdBB
	nEM6ygudBNTwco82Nvk/dRJEbwtJIjut+qrAMeM9IqCkxBZQaMVWNM2RZAhEjUDgifgF+wyxLlq
	1DGLd6pS1BNfd3V6XF3Bk3K1ZShBOy8DVn28xJ80zMjYXVBvTipyt6C7Xb7HDHLo0LllPWZv5oc
	l3HHYM=
X-Received: by 2002:a05:620a:2701:b0:915:eec4:49ab with SMTP id af79cd13be357-92ecf5dd3bdmr1127366485a.51.1783652934221;
        Thu, 09 Jul 2026 20:08:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cf78a5sm97038385a.31.2026.07.09.20.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 20:08:53 -0700 (PDT)
Date: Thu, 9 Jul 2026 23:08:48 -0400
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
Message-ID: <alBiQArmsWFg975w@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <6a502267b17cc_3b7ee51008f@djbw-dev.notmuch>
 <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
 <6a50356aa7a4a_3cabcb1008a@djbw-dev.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a50356aa7a4a_3cabcb1008a@djbw-dev.notmuch>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3210540002
X-Stat-Signature: yxpt7auu77yt4ikwag4okr6uqffueker
X-HE-Tag: 1783652936-450938
X-HE-Meta: U2FsdGVkX19bo4QtYq2QH6UwLDNNX2CDPvEx6K423v9f2GVKwGdWt5GPkLvEWBOt780A+g7bhRJ6/EVqPNwM7zzzfzPGE8w4p4LyalErVKPjUflKmFb3VvBNQKuPdqAjek5DnxPt+RUiQpKjQ83gw4WXvZ8sA5w9QPesgAQYMGNO2r0qJZtqnKryDrYiKFGl19iMdnPYJId3NKT1ZOPkFOoH2ODhMi2R+Skau7SH1VLHoCJsKuWaRGxgKdJyiKOsH0TYK1YHls5Lmraygp+0pphBlxOVzPLdKaVjT3oIId7vJ50uHugd526c+509Ho6XhppdGEvOSpqrEN4Uqkwlj+D4eonLcDvjj2QinvGIjyXxDz7Kw+Y1OCZ0Lwwr+qh4XiPfJ0ZlctVj+cFgtD5ZP7MU6XRTGvcT0bPLLKK1yVXlDuT5UTNVVW39Bcyu8V+g7V/V7+L9A3cgHBDv0dBv1TrjZuHfcji9N5hcKnViOGiCE1ZJ1m3f5nP1CdQkATkZgSzeygRp+oSdv8lRHtA9cmmQmjuehUjb6Rs0kt8jvBCGYoQ5Spq/3cywL+1sZADP7wNqCEFOduIuvew+Ybwzo79cUx35O6c9O/D3JUr1zCWBsvuIHo1wMlZSdo90+CrNw8Tp1rJNrGMO51cya6yuIchvykzB8sq2Wnna0AzfygjfgcpUhtjx/6LOM47ArOvj9bDo2nC86MqT7Smj4dZS3PkmiaJTIh+OOZffLGpUug/aS/jLhqZwwEMURZP/deKtACiRpvWslkmp0T+PywCDdxZwHzZxB3N9T1hY44IQsLuRZWRMeZwgpCVqZLSqM5CLEs4OrqdL69szjTBSHeihEq0NF0cxhEGWP4aeuDmdiPlDNZcKgVC3czCmCAll8GrCWYzXrxiInBEz0OpvMo2yJf49JCKM7Yj1veY9S4XpSRFQ2qFtpvPNBmrwzMF1hYXRzD3fVcI257s0ntmxo1c
 eiC8/QmG
 6Tt1jSvchINc5KBIX5zJeiy7iQ0d7JF3GEmivr+/jYtfEChxIuQ6U3iRSxjr3lEz6aFajH6jv3hZlSH4kspav8jgtdTPCOT9rAl6h/MT19Y/sfBKLG9L970bxfGRSxLPbcNFJofoCsz7xwb5eaDdaNIt3q+q9Tz0cV4FRBecuqzDnw8TFlMQT9ZPC1Xg0OTkLVgoKjJSnr3yF9TN+KlWHJ3T1XrogOGxOf/DxoC9/oTjKhFcr7PZ9d9nE8FlxZykUpwsMJq44RpyhAj5ojrZw4UokFtou9cjEcV3KggwcWnRvQzD0frL5jrS6PACGlyMp+UpFJVubYEs7h7MiHChzGpdlusDOfkS7pOPmY7slh8BTsEqa6Rg6US5VCC3FwUxtsMAt4N1aLhWLrwX7McQgtM5ynw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 04:57:30PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > > So the "unknown" case does not need to be here.
> > >
> > 
> > mhp_online_type_to_str can technically return NULL, seems better to not
> > just let a NULL dereference sit latent even if we can visually tell it
> > can't happen today?
> 
> Oh, makes sense I was thinking "unknown" was only a result of the
> drvdata missing case.
> 
> > > > +	if (dax_kmem_state_is_online(data->state)) {
> > > > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > > 
> > > I like that the BUG() is avoided, but I think these should stay
> > > dev_err() given the severity.
> > > 
> > 
> > I had to go back to calling remove_memory() by default given different
> > feedback, but I think if anything I will just modify the BUG() to a
> > WARN() and call it a day.
> 
> ack.

Ah, you know, on second look - DAX could never reach this BUG() in the
first place.  I think this was a hold-over from when i was originally
refactoring and trying to figure out the right path.

If there's a desire to soften these BUG() to WARN(), i can submit that
separately, but i will close this all out with some comment updates.

