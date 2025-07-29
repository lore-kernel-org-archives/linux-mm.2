Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111FFC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 07:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45496B0095; Tue, 29 Jul 2025 03:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5BA6B0096; Tue, 29 Jul 2025 03:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A9D6B0098; Tue, 29 Jul 2025 03:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 815D46B0095
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:53:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8CD459485
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:53:37 +0000 (UTC)
X-FDA: 83716537674.08.4E17380
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id E6FC9100004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:53:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ShBww45x;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753775616;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsVo12V6n1cHZPjfQGvjTgS28eByrDkHggKW6JJVbsg=;
	b=fYaFBatOWOb5aLsg7iaHAYbn044lmR98V0ypOp5EhD5f0TNxkwgN3W7rhmmmxlGmdpDgES
	IJmbxS1fKhzXAXSJRRZ05ZI+cat6Gi4aNYURV2FoHDZ7NWBIzCEYwhl8iC7mVtET7ksoYW
	LTtplH0/693wuxw2WSSc6PSb+R7LPXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753775616; a=rsa-sha256;
	cv=none;
	b=cNMEKV9vb8BQEOIEK3E22YLJWKlWlWHDCHUvGJ+RuRjwE1kyyl0vNfgs3kR9H1ixX8znqq
	IOpg0y7EEga6SDOlvlunSt6lC/VXg9g4I3SyI8sBBqa8K6p1Cq104Mr4jC2DVkgZwtfTsI
	NaA0lQpmefHk3J2rmlio9W8AlmeZTjU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ShBww45x;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60c5b8ee2d9so11058082a12.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753775614; x=1754380414; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsVo12V6n1cHZPjfQGvjTgS28eByrDkHggKW6JJVbsg=;
        b=ShBww45xV8cSg9IN2ECEaXGDQ73aK+AgbXvnyuE+7aCGDFBW20WBWPBeIvuQFyLkPZ
         2zOMkmW8WWrGY46OoYSSQIoMZUAKIq8pkqjMAG4PQFNfoWiQJgCQCwubK18JUnkoPTFY
         DeSzvOyZhEEozhTU1g3Y6srYxU9u+1iVQyHSNXv2GLXJLewoxvW8yUgYdpq/kB5/FzRc
         BM30jZzkjAFq88cA6pVsano4wEgPlCLlczdJcskOs7MKFv+06uFNEMLCnr5jv1d9Ag+S
         aWRmMtrgAylDEPvejxMisG6s2i289wEekVXJ7OVwsKkohC6/tkACqTjlhH2fz6pkj73+
         eW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753775614; x=1754380414;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xsVo12V6n1cHZPjfQGvjTgS28eByrDkHggKW6JJVbsg=;
        b=Exq96LXKW2Vt3bCO+cixj26fGEqRwQgI4Wk0Ulsb+uRdYGaxyxeAlaX4J219lJTY6U
         UnP4EvM3DsKMCgcYiOHcDMFWJu9RVv+mX3dYcQrkFidz5ZD6YQtI2FHMzNWJN7fe/WMK
         9gHtdWYUNVWHdOXWI2n5jtCXr/chYdBlrm4dP8eCTY1SNI7U2oiyShtEITY3KaTNeAn0
         eIxwdNerToFYcerjTqBbmyNZwFJb2mufiykjGCfPIfysoxcOo28rGHc7gs+ZD1oM1prd
         SKUCqZC8JAcBJYO3vbSdWo9KrWSackNHBqbk6oqgHVezd8Jj11/VjgKEJ7i8ATzHlbjB
         vx/w==
X-Forwarded-Encrypted: i=1; AJvYcCVo8YosSYkhC6LXNci6MsjAbkXoPWiNdyobsxvg7itDU/+D67xy+YZr1sR0A6HIOts9OQGJpoFOxw==@kvack.org
X-Gm-Message-State: AOJu0Yyh8oDMLld1IYETBEMW+GbbkLgLMhzkqMiE7ithnnY1rm+0/rAe
	DrWGQ9A3SlR121p4oT2/XJGIllj+IRDDdwhXSZA+0XxYZgA8r5e1O5PY
X-Gm-Gg: ASbGncu7v94jQEXQrya5tKQ9uoRv3D5RBRNb6FE3Vf2j+5DD+4pJ0DI1PPF7KRO4hzo
	jB80ighqy3jYPDzrvobqDasFW4Q3cgMSM+CTXbqYrtiHO1W4kLn6fMbvk084+Jn+bnLARrBrZ2+
	33E+doT6hb8yhBs4YubnnyasVPvGMe2hR7/mJEfGa1aMIoespCrMrw4JdPF/mNF7oSuJq20WWiF
	Ka17YlhRLFMxqC+SfNzcWe0jtQmWZ3dkMffBJkbXxv2LrimgTOkgaYNg9uOSKvZyrsxhaL38X7V
	IzytpFSLcSCj2z86h4B0bh1eqa8Xb5bwiVYmICm2oR5uxKfs+b1g04+kWqVRDe288ho0dQh083C
	S+Zu9QNIPq/JXGkNjC07fQg==
X-Google-Smtp-Source: AGHT+IGAnknk8rhP20f+2sNuwxA4iW0E1pa7hcWsSRXI9dwJsSvI+o2WMSlmcCRhgf1zJ9FE5orwQQ==
X-Received: by 2002:a05:6402:2789:b0:615:4655:c74c with SMTP id 4fb4d7f45d1cf-6154655ca5emr5234235a12.31.1753775614152;
        Tue, 29 Jul 2025 00:53:34 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61556326ee7sm1444188a12.55.2025.07.29.00.53.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jul 2025 00:53:33 -0700 (PDT)
Date: Tue, 29 Jul 2025 07:53:33 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2 9/9] mm: rename vm_ops->find_special_page() to
 vm_ops->find_normal_page()
Message-ID: <20250729075333.47jnxp7fly5wfx6n@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-10-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-10-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: E6FC9100004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7kbizq63qw9ek9s9pbmg6egnqwqdj6rp
X-HE-Tag: 1753775615-960484
X-HE-Meta: U2FsdGVkX1/Km2AsV0zWpVLSjofsQCi78rX9B+6U0kgQzGO3rqokayYPHAQM8ZRfBahAnmtj2Xp4MUfhDeFRxrchh4s0RIDr+Gn4wzQcJqdTTUv27shxxn04w86SddgXXtxZ2gowfmgR6eiTfAFiq1Ti35DGEUPQgd3qz7VdeqNinKDfN8QpN85vlN0VE+xbpsMC5ZFqXmKkip36GXwEphxubGqjIFoygMXuSKfaQCsCzmwlKstsQZ89fYaDou/GChqIus3ILT+d/zFnve9iAOJfcjKsnm1LBjfrV5uVXQIZ7X/+r1lEe4W7hccSjxPqceoqWf9HAJpkVo9HfUsPPZtQCcVcZd6kHe5ih7tmjuSRjJTeJRuLLO4lFxVUQwcEX9ZGHUZaL5fhrVSdcL50XX2FUVIkW091qX8AdaAfFb8rtFAprpSWuKcHsconPEIJIGaysTiBfb0nIiGD0oCh4Xm7LD1PFQ/QaTeeD1AAvXjyS2Pr9wA/i+Y+wIPL9jSDOgsXPA8U/9dLD72qCeoQ21t5lIok3dHcqLfQPe9gRo4v7povtSk0ApoeRfm0iVVRpldgGU90dNfRzgUKl496HDrABiQPWuWim6m4JbQ0SJwuQNboCUU2Q0eywW+Rfl4r6z59Ky5PSG6Psz2tC99ImTOS2ym9DcvKHuiPQGspq+wQqBAptEgIID8AuhTIPTXB8euTHjupaEu1A/Pv2ERqMZFHfDi/CDBaCY+/May1gR8wjqZL1CUk7P/b2DswglXl3UtRbgI9KfSKbrar6EIRmKtc4gfyZwkJuYRKQd46LMc0NotxVj8MOGHVgRXKAw9G6SD3/+49FpuDQKNsuOBXQaFw/IZuzyw/ot6hqsYFJXnCvk4F4uexmiIBUPfx2y8wMcb5KHsVhFAue+Wl04cgHlkwnuz8rLAcG12dr84cKDQfPKPt+bUWtIZ3SzVGgDS/xZ/q2qZ8Ty+8JulUqHT
 SGmmlEcr
 bC/jhwyLUQrQG+j8o8YPlQqCUHw/PN8eN4zl2mffp7ajg4Ump90jwRQXr3YzzOXmXjv1MTeD5YrYb2hj0WkA1DSRq9NLpp7q8DGDkpgmQkB99LrtuDk43FkHMZNQIHZQlb9cxgY1qJynphoIdOtXLX3zQMjIE4FkhwnNrM2sNUBO1xf3MtT7gVuYr9rxE3DU6SzsvXw4NO6+AtS+e44pNhPbM7wLg4aeKyVnZPqzC5Lmv/Uwgek39jQogYUd1dWUXRnmQUfI+domjhIqsvsIjzQkW9/4b47PYsGXgkKpKpU2kkFFrMGvccP/PMD8ipjCabt91qpx18gOC7hoWrIYWe+/LRk9qGbkjdtOGlJM110PxpNrEvfXhx7/TvUfKmDBSeDp2Q0meNU7hQMt9O7Ad0JNgt213QAHrtlqj44woGPhxMd5/A/Nnvg28GsLAC3GRrrnJ8JMzsmK/Hk5QIKcDoIOSxjmVzBq6qwrXDMGWlTFQM09AHE0j8uOIBkxvKzBDESInj9VJW3H6v6kO+iWjijTcRZUpAAgynMOM5sh6WTrhoHWspM1y+O1lyKu5gXDeqCXBNYbdtVHSspdn8SOvSCJ2DBnhDlu9ti0XWkLX0pqpR/XMwHfQBd5KEhWbmOLA62WFSpPTBFkJOlH859HmB2rdgd34yMGUNUJatxM2jHioDIDYhLh99aOjK8wm0miF2ehFGESjxuEOF4c0cNnIj9T1Sgy8yy39FaizAE9uq8l46zIyNfgEpC0pIJF/DApgFXmq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025 at 01:52:12PM +0200, David Hildenbrand wrote:
>... and hide it behind a kconfig option. There is really no need for
>any !xen code to perform this check.
>
>The naming is a bit off: we want to find the "normal" page when a PTE
>was marked "special". So it's really not "finding a special" page.
>
>Improve the documentation, and add a comment in the code where XEN ends
>up performing the pte_mkspecial() through a hypercall. More details can
>be found in commit 923b2919e2c3 ("xen/gntdev: mark userspace PTEs as
>special on x86 PV guests").
>
>Cc: David Vrabel <david.vrabel@citrix.com>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

