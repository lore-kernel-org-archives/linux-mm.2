Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E14ECCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 09:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528948E000D; Tue,  7 Oct 2025 05:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8F58E0005; Tue,  7 Oct 2025 05:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7C78E000D; Tue,  7 Oct 2025 05:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 290788E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 05:42:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 907491A0868
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:42:15 +0000 (UTC)
X-FDA: 83970827430.15.9A64425
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9135F180007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:42:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ghGBNfO6;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759830133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbTmSFrTbV1O1JezcHCIzpAuTai20RptyHEWwW07HhA=;
	b=KvPPH137GFlP110rz4aYsBFvP1JvXxwQT6pgSXPXtrEcTcsO2TLDyguArFTIxwyXd51S8f
	xk2p3jxKBKZsSvRFYpDYgQT8vDR+SMNBbU00m+zajVslfg+I1PHHkZ7oqCerbyd1KjglPv
	F04Ql3r4UyR+aEgaAcKcIw4/ISu2djE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ghGBNfO6;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759830133; a=rsa-sha256;
	cv=none;
	b=GbY1DWdd3Mw0Bid4Tke7WuujjwcTYJkPDlkL48ZiigV/wOgqrTKv7TklCAJCrSOtTE9dHI
	QI6lKeUYXMm0AMpl/N2GaLsjoPgiz5t/8rWuvbe7Ort33jzvuwR/q0iav7upgvwkhzdAH6
	nrXJOcIZwW2oOTBqHS15rfOwgOlLCW8=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-36bf096b092so57420441fa.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 02:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759830132; x=1760434932; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DbTmSFrTbV1O1JezcHCIzpAuTai20RptyHEWwW07HhA=;
        b=ghGBNfO6dKBwRNiuDbMzaVY7qHaShc81s/N5gU+K4nkOVFWsTrwADOTYFTgep8YD+v
         zOyU9AKjwHTAPs/hOjaNxaAiRn8mBslwl2VjAUQRQLP5sOiMtrJqxKdFyJf9EQUVKrbO
         MgPA18RtD4pdt8NRK/lRhExljM+VyaWdacqsWawnA9AuHH6UDOyKr/Jic9vq91veXOcL
         7qwemvaneNppEqys8hWxhE4HQlUkW3LB/E8u8aJB1PHTWuAh/bVbXbXYMgC3+QPa6GAN
         zunNvjzuD0npL28Hb1cmZCppG4I0jY51yQZaZJKlFc9tHio8Ex/cYf8/UeJzNNxRpRDk
         i9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759830132; x=1760434932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbTmSFrTbV1O1JezcHCIzpAuTai20RptyHEWwW07HhA=;
        b=eX7PmxZDD/DKp0wzSnAQV6XicjMFdU/jMxxw6jgwklkPZOmT8NoSlz4RXCr70qdMwz
         ALfSuvfZaSImEJi3lg/5h2mXDQSVeHaR0T33fYTm8xYahnpM/kbQZOtphhpgTRB3e/2A
         99VMRsloO02ww3gIorMGNUglknWQr6gugDLZq/Tjir9Z41+oLkDqq+VXCWhmkYh2UP71
         VO2Zl51/I+65jHwBJaZbLaquCOJB9EBHbsCxrhO+Dr3HNm6tB8BVsIL9o11y8eQpSn6+
         5ULWCIb511+wpWrOEKvKEUcXEQGh39D8wMD4+mdiSmBYJLtGqeR1OA5IHBz5t0wsLdXI
         Zn7A==
X-Forwarded-Encrypted: i=1; AJvYcCXV96vQ8+I+MiJfd9A7kiVJjh01mb0AvyvbJ7IrV/nJtJZqfV6/MAerUyzF7pRD1GULEKBgLDsj8w==@kvack.org
X-Gm-Message-State: AOJu0YxUva9CGzS3gDyvR/bqbQxIJOAfbQOV40ksvAoGP4uQLCFYuyRh
	OpTM/BHx0vcH6nL5k9pMOxuHx0rPQQVmqhIzB3DzU8Q1i8rKpXCcbaqk
X-Gm-Gg: ASbGncvt1RbFKkO93i3xJW0HlXH7B4Z0VeVBqjDXExUU2988FhWfHxhPIoYd0NGr81U
	lMf0MClu5zIZ3JqTLxOduf3jvEhcnRXR4nonD4EYPZRWm0QxBjylKffEm3rBwRuECRx8pWcE6Zm
	VB+wUfa0R5rTy4EhkNhSIryn0FfujUXedmEtn/F64XIweKUCs3XwXip9b0Pvjp5OYVHYjA9h+3j
	sFcrYz/itOP+zPZ5OJZpXEUq8G0hhF7TGss2aHrMtwCb5cmSncDUx0tFfa44UG9Pu6z1vOpSguN
	dp174d2/pwkh56NbmxlnJYOQ1Tsm62Y1mRWhVFnCXk62BocT43MG3rMuVsgjm2mzwk8AoxUkcM4
	FB33axprekB+zpA==
X-Google-Smtp-Source: AGHT+IH90oRByw3mYhklQK0+LggQwiGhBDsXqhGzOt+l3haZ/I2j0XjdugbDK1RzQ+XS3wKV9EGIPQ==
X-Received: by 2002:a2e:9a0a:0:b0:373:ab06:1ab7 with SMTP id 38308e7fff4ca-374c382e880mr48480771fa.29.1759830131285;
        Tue, 07 Oct 2025 02:42:11 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-375f39f8b8fsm8512171fa.14.2025.10.07.02.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 02:42:10 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 7 Oct 2025 11:42:09 +0200
To: Baoquan He <bhe@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 09/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <aOTgcZWGlcx1TeDX@milan>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-10-urezki@gmail.com>
 <aOCejd0aghFS8iSO@MiWiFi-R3L-srv>
 <aOCqSrnazd2YwGbe@MiWiFi-R3L-srv>
 <aOOUlW0SbBcPM6Mq@milan>
 <aOPBePFxNk5FP/ru@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOPBePFxNk5FP/ru@MiWiFi-R3L-srv>
X-Stat-Signature: nppnbcu5bypx7yn9gjpcgdo8fxkt361a
X-Rspamd-Queue-Id: 9135F180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759830133-809759
X-HE-Meta: U2FsdGVkX18pX01suCeNglAbAhyWyWrGloTTEW8GaQbyWNCYslD5qBS2kGXxOxBMHo7Hqljp1X8+YKk4+4rotO9VsWmxzgX9m2EQTzqTOkcPPPxFHmRxZ5VBD+QCSLzGO+dIEgiNW29VHNG9iKPQ1bw1H2am/u7Z7COaCEgX5VlFLeHx8iknZi5QZqVlkpTgR6g3UYqngq9NRZKEbJxqUxoHpFfF0UCTq0tDWFJynU/2I37JdBo9x8KIFrOPwcvQO1k5nhc/ubor+I0tHTbOBgCGLE3x3nSNDok3VEUTc+kT3d2RngH6foDY02Z5gY2KMVWipqtEQgRChhn7NWlA8J1pLIaCarMvkEIy9IHj5yli0KbDI4VYCbdardgDiNXzySntuXDb8SwjDc4x5eEMyrkfIoZFZZDsWbqxp8hWm8loWRmowUvbbXAAtRnmc8hPxOgedLxLkEqNKEDpuzUnw2T9nHIp4KVFVkyJ/RiB9L2arTFkieKIdpMFgEy9P/Sn2RrzSDFNYv8v8bOXwn6Ct4auEY6khCzMovIRNM8bp3R1of7G7c+dajZkqZ77MWdauenPMXeJoUJlOpLl9n5nPO3FEMCipVGgfMfk8Dgs0d6NQtiMfrOxQ+VrtbntHMG9wY/FWa2IwuW/llofPAHtBZD4Rvj+p4Xz88ZurKwPBJKD66sFA4E1wJn9bBhZcdXGFkqjLefdAcJkML2zCEevHP8E8A3cvW9eaN0P15ImdCT37g9GbYEBHspOPFhgfVjFBtwuG3//TygrC0+4X2Qh2+xm/hVWoEXfBRwiHcOKHK/3Y0f7xnlAaZDFAd2VahI9FHem6AyG/6rEQ3iKgQRZvYTM0JuE3jRuRGKrS6sEDmGCcV2DgxSqWEgQhOSGns+gu0PRMSWoWt/cDq0x6UyHYzx98dgGcDJcRSoXowY9fnnGrt379TB8o5curgzlmNv6m5MorlMxafoh8CL0QIq
 adrK/Ep3
 53ooCqPLqx+CykVfklC8xKu2fGMCMQFH9XlvhOxrltTJHXUYarCQdGAntGFfpnzpUvMjS5iWZ2qDRmm6zgeSNMqyYLqG/j8SirnxRIcLgZ1SsV7ckVF9txF+L60xykwbRauaV/s+ZZW6q9X1YCzI2cS/4S0nRu6jHBIa6nQ5bqP7RPxmLyBV4v/Y1/XriVGU++ZkdYBEEneBh27BN8fCXZ5lUu+n0N77WTRSpra0GdGxuInyKhLa3FsjOWmiR/N1wP8JiBibIYCdsnjOAvPHgsIcnmF7JzOEAtIhOFGPdieLFzEV/6lMemTOfT6AN3MiE77Y2BIK7twDesA2gllMAYYmYzzixxWO2Kc0ejFXlAe9iG9GKmgRu4a5ryllzFYsvIonY4nQ8V7edwHz0J7D6VxhORasq+1OG3k6OvuqI/sx0509boLnLkJGcvzZMQRGbBnpHYKak8nN8ZxlF18nD0SCwFRTI24Z1xumWYaUbAJ0QIl1giFHuPxiYV+Z7IIIR1QVpjAdt13leKfJQW0dOG5AofpO6NHGahck26ZjULJgyob/XELULdqfjd2UE3nuVaNfpvwYS3f3mR8rwZjeaZWqikIO8awOzYqJ+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 09:17:44PM +0800, Baoquan He wrote:
> On 10/06/25 at 12:06pm, Uladzislau Rezki wrote:
> > On Sat, Oct 04, 2025 at 01:02:02PM +0800, Baoquan He wrote:
> > > On 10/04/25 at 12:11pm, Baoquan He wrote:
> > > > On 10/01/25 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> > > > > __vmalloc() function now supports non-blocking flags such as
> > > > > GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.
> > > > > 
> > > > > Acked-by: Michal Hocko <mhocko@suse.com>
> > > > > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > > > > ---
> > > > >  mm/vmalloc.c | 21 +++++++++++----------
> > > > >  1 file changed, 11 insertions(+), 10 deletions(-)
> > > > > 
> > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > index d7e7049e01f8..2b45cd4ce119 100644
> > > > > --- a/mm/vmalloc.c
> > > > > +++ b/mm/vmalloc.c
> > > > > @@ -3881,19 +3881,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > > > >   * @caller:		  caller's return address
> > > > >   *
> > > > >   * Allocate enough pages to cover @size from the page level
> > > > > - * allocator with @gfp_mask flags. Please note that the full set of gfp
> > > > > - * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
> > > > > - * supported.
> > > > > - * Zone modifiers are not supported. From the reclaim modifiers
> > > > > - * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
> > > > > - * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
> > > > > - * __GFP_RETRY_MAYFAIL are not supported).
> > > > > + * allocator with @gfp_mask flags and map them into contiguous
> > > > > + * virtual range with protection @prot.
> > > > >   *
> > > > > - * __GFP_NOWARN can be used to suppress failures messages.
> > > > > + * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> > > > > + * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> > > > > + * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> > > > > + * by __vmalloc().
> > > > > +
> > > > > + * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > > > > + * and %__GFP_RETRY_MAYFAIL are not supported.
> > > > 
> > > > Do we need to update the documentation of __vmalloc_node_noprof()
> > > > accordingly? I see it has below description about "Retry modifiers"
> > > > where gfp_mask is passed down to __vmalloc_node_range_noprof() directly
> > > > but have different description. Not sure if I missed anything.
> > > > 
> > > > ===
> > > >  * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > > >  * and %__GFP_RETRY_MAYFAIL are not supported.
> > > > ===
> > > 
> > > Sorry, I copied the wrong sentences. Below is copied from documentation
> > > of __vmalloc_node_noprof().
> > > ====
> > >  * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
> > >  * and __GFP_NOFAIL are not supported
> > > ====
> > > 
> > > 
> > > > 
> > > > >   *
> > > > > - * Map them into contiguous kernel virtual space, using a pagetable
> > > > > - * protection of @prot.
> > > > > + * %__GFP_NOWARN can be used to suppress failure messages.
> > > > >   *
> > > > > + * Can not be called from interrupt nor NMI contexts.
> > > > >   * Return: the address of the area or %NULL on failure
> > > > >   */
> > > > >  void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> > > > > -- 
> > > > > 2.47.3
> > > > > 
> > > > 
> > > 
> > We need. But i am not sure it should be fully copy-pasted from the
> > __vmalloc_node_range_noprof(). At least __GFP_NOFAIL is supported
> > and thus stating that it is not - is wrong.
> > 
> > It has to be fixed but not by this series because when __GFP_NOFAIL
> > support was introduced the doc. should have to be updated accordingly.
> 
> Maybe just remove the documentation for __vmalloc_node_noprof() since
> it's only a wrapper of __vmalloc_node_range_noprof()? Surely this should
> be done in another standalone patch later.
> 
Like below?

<snip>
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9a63c91c6150..7ff81a38dcb8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4027,12 +4027,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
  * Allocate enough pages to cover @size from the page level allocator with
  * @gfp_mask flags.  Map them into contiguous kernel virtual space.
  *
- * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
- * and __GFP_NOFAIL are not supported
- *
- * Any use of gfp flags outside of GFP_KERNEL should be consulted
- * with mm people.
- *
+ * For detailed information about supported GFP flags and retry modifiers,
+ * see the __vmalloc_node_range_noprof() function description.
  * Return: pointer to the allocated memory or %NULL on error
  */
 void *__vmalloc_node_noprof(unsigned long size, unsigned long align,
<snip>

--
Uladzislau Rezki

