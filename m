Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C402E674B1
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 13:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CFD6B0088; Mon, 22 Dec 2025 08:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4336B0089; Mon, 22 Dec 2025 08:36:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7106B008A; Mon, 22 Dec 2025 08:36:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA7C06B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:36:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A23841297D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:36:25 +0000 (UTC)
X-FDA: 84247206330.11.AD3DCC2
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id B4762C0013
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:36:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ADLMqb7p;
	spf=pass (imf28.hostedemail.com: domain of grovesaustin@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=grovesaustin@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766410583;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5H7iZ45FrF2tS4o+Y42wdgxFFcoGprkixQX9HHYUyv4=;
	b=KPn9Y8QLUlMOYHoS/yGwgBUGynYganl3IJmH6Zvy1nVtZNHK8HGw2qFeVrIdRYr8TFDpJ5
	svyTdRlhzeUfAYdzJzjSNJx0SmLkhJQH0IlXSWza/OZ5aPfJQl99sitqh7vJH09wI/kUC2
	ABwmplmu1ENmhYAiL2b4VLkOQhJKvdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766410583; a=rsa-sha256;
	cv=none;
	b=RgRVWof61ZDT6JkZiTnXX/kEkYjFA/uHJsOw1Puv1dydzk42I8x+9UGGoU2bG3FybUX1Qk
	Wwi+q7ZHFqAhrntLXu7CwufN62d7eoecCS7VFdnAAL+uS6In4oXHYb3wuLPXqOOjC+FO+c
	RwfqfUaJ4gmETEDONpodLCmobeelwBM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ADLMqb7p;
	spf=pass (imf28.hostedemail.com: domain of grovesaustin@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=grovesaustin@gmail.com;
	dmarc=none
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-450c6f5ff81so2333177b6e.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766410583; x=1767015383; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5H7iZ45FrF2tS4o+Y42wdgxFFcoGprkixQX9HHYUyv4=;
        b=ADLMqb7puffNFP+DiN6Ev0ucsjXdWBRMi2D/F+TwLA01LwuYQDWQ7dC95gpx3HHGlM
         3yKxTkEls58cXj74yCf7Q7NV4WGTIRMi6+FCKtwRZhxrnh/WPfZ0BFMYLipG4nyEiafe
         QpWzKATe7J/Z2a+9nkb+O7U5v9OG1C2bM9Dz4z+CHdVlr0J4dr1tnONy0htP7Q/FOf58
         xh8Vy7Vpek70AZvyqQFKcbxz6w4b4zhAM952SUYoOVYkkyc/92LI54pDWawIuazgH9AS
         bxfyh0Pc0g+ljtKqXrD6HD5eCI+0wEWpFwUOAesKQuD8VUuzkSLqds9cz/x32mTOJCDh
         UaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766410583; x=1767015383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5H7iZ45FrF2tS4o+Y42wdgxFFcoGprkixQX9HHYUyv4=;
        b=QirmkAwO/k7+1X4fIYdB3Q8vSfUkUKwV4FKXYwk7EdFEQCEMsc1x5hNS+Vqk2RvCov
         ELFv3q0mglRFPXloOR5h8J2g0JXXL5Tc7+M3G1hBTl/XNlseOfqg15kcI4X2p12jbvsR
         T4C3AwjstLpS9vXPHTy6k5f8rZnOIzH5XX0XKAyi/aTajTDwaGJddZjL0YDq9KHlLs9x
         zufGyTgDgZ5y/INN17VVxUyA/lVKTY1ZhYemjzT+sVWWntrkJZnYmjqXKXHdni0UwpyX
         YEu62tzCyikRV3HdEfozojBFraAZm5EDCdd34cz/pdkMcFx0oP84NwkGY2kMdqqGbCN9
         9gNA==
X-Forwarded-Encrypted: i=1; AJvYcCWgAMLIXndtABuiBBjqfe6sVmCJaj1qZDgAIFB4y7FCzSFxgJoRzLQWd4GgBNFYOPThnyR84QE3jw==@kvack.org
X-Gm-Message-State: AOJu0YxlP98NGtC/H7XCQjJuFCe2JWcPkhe6mGJVI94ywSCzf8ZLzDhw
	gXOqJeNutyEHbIryvBes1aorBwMZBdTINDPiydoMflEfj3uh20MkqkBR
X-Gm-Gg: AY/fxX68xGxPgp09hRgFp/PVnnXVOBE1CMgcVTNMaryLt4b8WxylSEPvBNxzSwkYdyG
	OY8DBvFfh4UBEwQZv9sRJqw39x1EfpNCmXYxHkM27f4qo32EoQ8KX8lMyvd54kOF9Y2VZzLpl6q
	eb+oK6dUseTEIPAeYr+aodddh1NBBffoPfPthdWGBUB/Kq5rM4O6KBvh/xWhDcPOma4HfT3eeTf
	2vbvSt47/5ulkOEG4/sNJ13VPXvEzkYy0aheeU0M6KI4JHpGw+aU0LmwptYO+LggzpkVMkYFx3v
	e8iwtudKV2s83toL8bJCylw0q8dkz98o0agvxV682yx1esdlLr+QIBgUVYEQeqtpiMRLvr0ojcF
	Cxf052p8EiRZysLipG+/2wzAgqrlqaTn3zRyBnP2tbVJOWeTgcLDcg83Ti0Ux5xMFGbKzJ5nvrP
	KjqOcwdcDnoF8DBS4lM0cDNrowYsyJMw==
X-Google-Smtp-Source: AGHT+IFMAbxBTC55OcMj8bbxTyNSgdWaomaWM/ZZNGC1HLFwksIkDaaw+0SMTuleI3W7IPjVWcJ9Lg==
X-Received: by 2002:a05:6808:3a17:b0:450:bef1:f4e0 with SMTP id 5614622812f47-457a28b3decmr6717499b6e.15.1766410582575;
        Mon, 22 Dec 2025 05:36:22 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:d4a5:e713:bd35:50d2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaa4e0d18sm6318415fac.0.2025.12.22.05.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 05:36:22 -0800 (PST)
Date: Mon, 22 Dec 2025 07:36:20 -0600
From: John Groves <John@groves.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Notify the "Device Memory" community of
 memory hotplug changes
Message-ID: <iugopjdd5u32zgzrpohhswmk3dcebkpgntkz4afuqjrjkdfpil@lyrdle4hghpc>
References: <20251220000327.3502994-1-dan.j.williams@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220000327.3502994-1-dan.j.williams@intel.com>
X-Stat-Signature: zrcsj8iwbnus3zsdc66e8fndtit1f4kd
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4762C0013
X-Rspam-User: 
X-HE-Tag: 1766410583-520630
X-HE-Meta: U2FsdGVkX1+T1gWLTLcFEf57hMh114P8ZLzBANRXC6MywjuMmAGoSU0v+Z60yN/ihHrPotKIcu4isYfyaVzIX9cfy3WShr/n0ZeH9bY+AfKDlXj3tcjCA7Zy9kyxpHIezCbVW9K19OCdzstHbUOriHt+ABCAdG+T+Udk/9bivM9KDPrAitv7aJjiDm7DTYtfC+DtgqKMRPuig27L2XlVzdc6tI8iAFaKdDXs7SfxJWp6VGqy2goW7JqDT+6+ZXb0E7dUUibtpdfSq2HjsDPmL9D+JLFMkTSRYZ07Qq1NapcrRC0lmcLpBOAYcc5yCtILMGOZ+tMRqFZeXyMXysc9t04/rOYO1wr0GFwX11hGM9gjNkVwZYiiekCpe9YThDxT3wL90uotZ7N1ZsXAvJAPzdqm9aOtKr3e1E+nFdHZmyNQn7nx5tCWQuCwOU9KMbvQFpIxyxRXuDswXlC5jsqCF7A/tErmbTejoBIx8CnKoc6nVhx4WsYfjmRrtxikpF/DAKUndWc03xwKDQyW96k/JoTH7fJCQ7SJHNCQKiad2ryA66JurNPV2zHkGiuowwN+L+26q4IOgu/6KWTnrOKEMDZTM/KyLvzOsgh7MMGJXPA3N9iZ26X3bPF0KUF27RX3tX7ZAtf743tB2TWaFSCNUbppyH7umxUSAZhJ19ys601rzUq4iBc8ln/vqUuia6dMeoIkgpiKn0f8JvZer5nAa0dFl6PfyUQFAwuk3vNDlJfB0Fo1xA0iggxn7OZOiQhtsxQBZdiXQyUPLXnjZPgf/tREB1c0vj7NnWzMtPwvvoAn6oAiPnLe/yx+bIyREgTMVtYPekp2eMCLk/EfLlgKuUmw9DLbKRJg1BtTggeZEJ9F8vZwVVBQyQNCqywZUooNOw+6nkh6GPYJZpRbb0qXUVplCkxAx03HqGXtIf4dtl8/JAX7iSxFXmC/5qcnMnkVM2M+1mSo6dPMttuCYtF
 dAGIz/dP
 B6jD9/T1L1gdDtekojHgTiLrhjt/RyBZdszCoWNwXIQGo9G13eWN0XSm93Du60PAt5sDQIJn0IeeVJm1nD5W8zgr+50pX/e8VPCbwrZkhLiOSfdDEZV7NhmMeVR+oZV8kyfkORhYeGLN9hjYF+nxitc0DdmZrYq5SC9d0ks30SGnujmIKCmJ1QHSBFxIH1pVV4Ectht6i/ANKuyCER4i4zOdlC/4QF8PB+V41E9aiz5VnjpOR+jKq9NtC8fHb4L/6MfLJxavEFHwV7I6w2w18oZ2S91nH2RlifDwpVC2Ql4kbwrWVMZmeMKK9waq1whxCk3xFfgDLsQA7GA0QfXRR34FvIeZE+Gv4S6VoiSPD6ekYlprXrKs1ACeHdqyz6KP45RevXGaAb0ZrDFTQ4ZfoTfK/j+/EPTAStTGyThAW5YvkEv9GT6GhjMjJSWI0mVHJ4ZpSchXxW12EFZaJ5OsYrqNzRDMcDUQglNn5DgfIe2we5uWNSjgijQnlUiMcsZr5z8B4I+1wS7kTOHAt3R0VLQaYhQDA1KV+igatpoEbwdsNA8DOUGFjr5nbJh1FVO/kQ99d+QxHO9lMMcoICLJ4/LnGJuv2uQ+5Ke26bNuPbnyXIZROYHhlJvO5TSB5NxXRvnhCF5FE8StRFldoGni+HDLIL/Z1azinSdlZUqya7TLDVFJww/wccAs/NUmPMh6+xnf9tAko5kZ30oHXlmJPXXi/XJHR8yxwQbCgCQZhwDVgShs2xqc2qFihPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/12/19 04:03PM, Dan Williams wrote:
> The recent episode of a warning regression in memremap_pages() [1]
> highlights that relevant updates are being missed by folks that care about
> core ZONE_DEVICE changes. Yes, CXL folks should pay more attention to
> linux-mm@, but it also would not hurt to copy linux-cxl@, where most Device
> Memory folks hang out, on memory hotplug changes by default.
> 
> Link: http://lore.kernel.org/20251219123717.39330-1-john@groves.net [1]
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: John Groves <John@Groves.net>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b11839cba9d..076322fe91de 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16426,6 +16426,7 @@ MEMORY HOT(UN)PLUG
>  M:	David Hildenbrand <david@kernel.org>
>  M:	Oscar Salvador <osalvador@suse.de>
>  L:	linux-mm@kvack.org
> +L:	linux-cxl@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/admin-guide/mm/memory-hotplug.rst
>  F:	Documentation/core-api/memory-hotplug.rst
> 
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> -- 
> 2.51.1
> 

Acked-by: John Groves <John@Groves.net>


