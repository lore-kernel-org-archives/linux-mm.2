Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D36CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B146B0010; Sun, 31 Aug 2025 05:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612646B0011; Sun, 31 Aug 2025 05:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FBA6B0012; Sun, 31 Aug 2025 05:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE606B0010
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:07:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B645B1A03AB
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:07:44 +0000 (UTC)
X-FDA: 83836474848.21.1A118C4
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id BFF72120002
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:07:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ej85xWb0;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756631263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGZwzPbeJSH40yHH/9NENXW8DuVrJPeqrN0UawxoQbU=;
	b=3fbaMWhcTp34es2TvITgnpuSn0T08JQ4cIvzyT9IuWjPs0gyL4O9XCwzDTVDJ00XakdC3/
	K7RC7leMEiLhZ2aRX+UobFoZdeZi4YohQv4rNRX8s3844NEZPww4T/E05rmfuu7TtCpS2p
	ukMeTRWIXAAzfgE6bZaDf2gNUAj12pE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756631263; a=rsa-sha256;
	cv=none;
	b=fHj1G2mMMeEvQ+3GS7yS21YJ+nMSZ46CUEFrkX7O2rAEr9XbY5EJe8mdoJE1GTIGPKEfUt
	lkOECp0gLEW0tNYCebbv0lK2lNW+KUV8nGQzmZw1aEaUa3ibhIeUTpisf09iNo6FWJnSa4
	GLfgKFdqP2NmcjWF81fB+fHc1SsVQ6Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ej85xWb0;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb7322da8so649829466b.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756631261; x=1757236061; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGZwzPbeJSH40yHH/9NENXW8DuVrJPeqrN0UawxoQbU=;
        b=ej85xWb0WHEemK6kFiD7SzRGdsRVmhJBKLbco6XZ+OckuEPY7Yq+d+fLAa/9oftzcl
         SdpyAc0OooPBIdohuUVnI9JxMXsphrSEmS8Oyf0gIP6qzmm5ER+w6a1yvUIZoif7g+j1
         gIoOb4YtLor5fmdA5ml4xYWF5b/qKlsksILbiMDXyrLR7P5cVY8KqAxDhwE3Cc3BTMc2
         nOL32P7NeC3MkSub0I9OSdSIYfQAlvydlROib+9EHZWQkN555P8smGc8FdxfNP7ajw61
         Bc/uNqh3jh5DwzpsrZpQWgeAZv1Fh6faveKQLdcfoP8qdoxOAjeO+CZHxPSpKuhS7EcX
         EYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756631261; x=1757236061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGZwzPbeJSH40yHH/9NENXW8DuVrJPeqrN0UawxoQbU=;
        b=bZlGZxdgsEAiUCV3GysAtPNJbvgbG1jx1+tfKliVl8ZIxBcKkGc7iTON3+UfrWYplO
         GQSmxBAQqa7jRYvmTPFjUsGMGeS3jafbmc/1zgXioMkMjAlbQfV4pEjRU+RxeevCfh+i
         Esnv+gMPCj+8Y7ebeM35KB3OpLwAXywOc+cCo1fABoXM7FrDhbeVoLkSb2fvJAHksmhi
         YfZQj8932rPp6rasn3ui4KCYdqf2Ph4qzno9uQFDqatLwp6pAlPFOa6N3VlNQRTWm8fG
         p9T+C+kKseNhKmS+iXzO+yt6E+4aFdDFwNw82/MDwlpxeTQ2hpzbOOR7uWAxuB1Jr5Sl
         F7Og==
X-Forwarded-Encrypted: i=1; AJvYcCWo6mnGIMAZCzLW9XQqHt1oep7GVVTeFa3YOZGDXCHk81BY8AKCRw5pCGpPl+y4R3sGKUgFaF2f9g==@kvack.org
X-Gm-Message-State: AOJu0YwIG2gZmQ0FIu6mo6SQnrkyi+3tK1MXxK7stKsamCpXRNkYsGcT
	BFWJTiX1CHAXNcpT/Weq/5P0GJnJ9uoAQj8ylJM8iFaCFICtuNL8KOPiwr5DO8F6+IBHFWK0+vp
	2A7frdmIKuPSZzq2TD6x5liP6QhJ0a1meqb1k6hA6XA==
X-Gm-Gg: ASbGncuaKtf5WMRetTcVDtbra/LSSQA8qUq0VLD73iXNIz895Ui+vfVZ050NZhe8wLp
	2Q2ID6wutfOAT018Wi5t5GUGu86KFawmWNNupAJ6hn1TCKIAaI8W+oG7P/4rLTdfg8JPKeEqnXQ
	GVDtlBw6Gp39QXjBkfQxI0i422Eu4e0lQfFAI8qFZYxsUiyhDVpPiA/NnkVC5be8cQF9FjwQXa1
	gLm/TZf3xZlhqx6x7X5Byl/ZxUw0hUYscZmrl8WIQEkSQ==
X-Google-Smtp-Source: AGHT+IEES7g66ko6SWQsN8+WIUxdk07+Eqy+DmB6hNaUA83IoCSXr1Pf68kunVGZ4gGRru9fXEUF2A7+RGCoF9PyX+E=
X-Received: by 2002:a17:906:9f85:b0:afc:cbf4:ca7d with SMTP id
 a640c23a62f3a-b01d979fe6emr455913566b.54.1756631261091; Sun, 31 Aug 2025
 02:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-9-max.kellermann@ionos.com> <aLI5dKVl_7bPqB57@fedora>
In-Reply-To: <aLI5dKVl_7bPqB57@fedora>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Sun, 31 Aug 2025 11:07:30 +0200
X-Gm-Features: Ac12FXyUUe1BE_1yIAq-T4Ag3V3wYcj4eFQvKTMVnq1a21mdj5Etofq7OAHlhWg
Message-ID: <CAKPOu+_VUMz5LxXEOVC9qQCQxjpHtm0dorJRxr34U1ff4jP7xQ@mail.gmail.com>
Subject: Re: [PATCH 08/12] arch, mm/util: add const to arch_pick_mmap_layout() parameter
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFF72120002
X-Stat-Signature: sr3r9whtafgak6rbn1nkkhgf5xuz35uq
X-Rspam-User: 
X-HE-Tag: 1756631262-901767
X-HE-Meta: U2FsdGVkX1+vxj9eRHta380PptAz9Tpld1+U9AhqY9WfDMFzbFI04rofI0NT0OasDq7eTNKFniN/CHr0wExEV2wbr7PQnGnDY0i+OOZwkMHyaOtQMdseye8eqfwjanycDrSeJfbcCosB5Xns0ftuzNXz45XNDD91h8CLUWqiuhx3DELqRhL/rqvmXHVyW+fXp+iHencDw+GCIy5buyitFfFtZwcnPxq/AaSH0Ht5LWcDErKUYdYWPu6TPZF7Gcl1otmURIp0+RP362kJhO0oJ4C4soY7HJTLxjxH7VULCimfaSKjCSvX54Ef8407sANXXfXu/I7/+WITMKgrlSBbmaLGTPTozG4HMqC0wnLAzZJfZjN5rYkrYRqBqQ+ZMiCYeLP05K5qse+huLN6WitunSsEO7gXjz57jhW2oWQpAOq4fZdorZ+y0sAWxLvU2TUm+KgwOuTZiMH+thYBo8i0JyiNmJdw7pQHgMr8U2VVbIKHOwZf2Lr/lpMVig3ZEP80874fYd8XXjn5qsNKLji6xImOfZGAAz3CLJVdrmu67mVSuYIK1gZQI263km8K5oe4TzEF/xBWwE+gwqhbYWCRfrULbQWijNvkjbVJiiM1zzQb52tnv4qAPfzF9nFqtSYsItHhFtZrXBkLBLXbqtmDPvZkM51AjVdGVprF89klIiXUzs+M+xGcycpURZYNw0UOe2Ot/i2znAcYN9xWV9jtnWk0mJCnnguLg6s8jx8hhxgTj/oCsxzslVeOkCwAUlpCXM5RzXMjIVypJemtqhHZ19WcjbTLSada4PgxTUwqYo7XKHajdlbTJWXDbnootW3cQNOyqHORauWr0JevWUSNtCDSz35oxbAh1Ty/px7IKxW4sITlqBhysR7WLN1KLZAJIswSAvszpt9RzKt2zjD4J0/pm5r79/BmxcDCFN+bpC5ijcpGLxmVyKqU6AkWVg45QjKnzfANgdDpBhv1cno
 3PChWYd/
 hZnS9liCEfcD9hhzJWdM/o2nxcMY4KNiV/QZQbgj5VXBbSqF/TOJGdhKESA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 1:36=E2=80=AFAM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
> > -static inline int mmap_is_legacy(struct rlimit *rlim_stack)
> > +static inline int mmap_is_legacy(const struct rlimit *rlim_stack)
>
> Thanks for splitting the patch into all these smaller snippets, it makes
> review a lot easier. But this function should be part of the 6th patch
> since we'd want function signatures to change together :).

Will do.

There are 3 copies of this function which are slightly different:
- arch/s390/mm/mmap.c (checks rlim_stack)
- arch/x86/mm/mmap.c (does not check rlim_stack)
- mm/util.c (checks rlim_stack if CONFIG_STACK_GROWSUP)

I wonder if it would be best to merge all 3 into one? The one in
mm/util.c seems to be generic enough. Export it and have its prototype
in linux/mm.h?

