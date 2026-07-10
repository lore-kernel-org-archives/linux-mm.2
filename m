Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A23C8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E186B00B2; Fri, 10 Jul 2026 17:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD8C6B00B4; Fri, 10 Jul 2026 17:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7811D6B00B6; Fri, 10 Jul 2026 17:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 462566B00B2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:14:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC98A1C3D4C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:14:11 +0000 (UTC)
X-FDA: 84974119902.06.5ABD51E
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 13A811C0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:14:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YXuvLcMN;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpMGBsh9fToTErr7i3jlVPE4gbDMnqxhA+rLBjZ5wi0=;
	b=kgoKR5Cev1MBY5hNE7TYo7jJsptpNJYPpCDLn4m/CO9DEP1opflA4mTVHp3PN0tM2dstHx
	uwGoSW1qavt3pmFgvvQdSK1aGKWt6BDsL/SZFzQ0UaqrQKO+lc296rZOMjjCxHK5XBGa11
	+UboLm9NdQAMU+CZp4qQyQqnuiUy7Ys=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YXuvLcMN;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718050;
	b=Rfxvk57abqBygSpuZZmf/iLC6g5Cb9JT8QnY46voCZpeLUGxRJJIm+P7G6GUr8bweeBFaM
	EhQ4gUuZ1Qq50Vfsq6vtAxqcAqRgxE8B4myCRD7JH2pYZ5INSXMEEn/1x649x0bi7112Aw
	WFpCkS0q801vxrydU0/7+Q5/1RH7raw=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92ea24a2dbfso105550985a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718049; x=1784322849; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gpMGBsh9fToTErr7i3jlVPE4gbDMnqxhA+rLBjZ5wi0=;
        b=YXuvLcMNO+MsJYtCZFrVpeSLdZVtQCc6eNlZabbhLxlpU26MalVW2kiwo1MKllm01u
         SLBL7aH4F/0anzRNNtHuGWj1zjelw3HMxCaJDcQUoCBtHJyzqmFDhQhskKZLd75kEGZc
         oxJavud3MgU4CO6NGjSxBLvGUiRWaD9OZt0Pd8aBAhOSFJ7fvpEUcfEUzPXpW69u5Bsj
         B2Jz0dnNExactsWdad74OKy8H9xHeqc+MYBU7QGHLr1Il9WjhxrZ/AWHxo7Xe0YwYvsn
         naQCmRJRHvQ4iO8/Cv/PBRAK0R1utBiIF9r0buvomoof/gF5jABEUPM5zxxzigRFqROq
         dbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718049; x=1784322849;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gpMGBsh9fToTErr7i3jlVPE4gbDMnqxhA+rLBjZ5wi0=;
        b=XB0JMW32VFxZuPteF6TRytA9cfZ1YJfQNRlO4Mje3Bw7uuGxUV7AVld4R+2sreDZSy
         v+989oYnrf9NFf5ISUrcKt9JEIodeJEQ5xxbWlGTJO3SnwoUVblzxOyKlVA+Ua4Du1Ft
         pVB+pF0HbOsS6zT3RoAJcNSGIfPPk4K7kQG3+MIxqItZnSYkyDolIissCmwLxZJlWA/y
         br648QgxcNkHFg7WzyYoR1fI2z3E/C+Xk/bfRF8Kotwx4Qka50mG/Iz1ypX8KlVl0RZv
         ihJ+i2m6rXWOruocebropiIKYVWqccny2D/nQsgya22BbsB0eKlolUOTf7PHe/vyV/b5
         jd6A==
X-Forwarded-Encrypted: i=1; AHgh+RrYVWp7Y+B6hJiN8w7TLjaVIDhzsankrus7tbDL2MilHUjj+C/PeatjH8IRtaOkFJn5eGbm7Gesew==@kvack.org
X-Gm-Message-State: AOJu0YwXwpXaVU++3jrnyLhZGl9b+YJcbihkkavI+Da5mAHUsRUHN+40
	M0iu1M8bGQKAKuuelGi+s5Y5ZqwurckG8REM+k3cOdz0kBC1ZtVkCrcNHKgdj7dX8GQ=
X-Gm-Gg: AfdE7clWTMvS/eQQnr4y+gy1gWt9JxcRvIOc5HCKLQPg7vRpFKC+NKUaOFYH7yYsYi9
	qxSRBCs4DhNdg6YMDkj7eHPKuwrTdaDwB2VGw4HLgkY3DTO7PAy6ZrOXFwJFGxilY0g3jgFJ734
	QIHGUlp2Pv8Y5AE92ReV4ZKXMTXwzs6vACL/wKKIqpAbh/BS6gxLyKRQ57yYmfxPjUc2n8+TuIc
	EYb19zgkufB95ebM6NSKuMNE83CNtL6tEO/S4kCIYAuWUr0t+WRGT7idsry9utSWebKao90Lk6w
	lDkxZBL80bk0p0MvWkUpcXn9X28It1h5MobcSjPzloPXKeTr9OE4GhUXd2HMwbha6aiM8VkBU9B
	3fdAJKLnZkN5R4JwH9111bAld29nLl92AEmkMhUYeVjQKABKbkOWyIY1uElGw3yFAQu5PJKJv9R
	JTbZ16X/OeQWyx+RBe3/2Ti9JVQH8ofOZjtDbu6BRmivFuuTuJtPLDlqsxVqZ8sL/4WaGo
X-Received: by 2002:a05:620a:458a:b0:92e:c117:9ea2 with SMTP id af79cd13be357-92ef2e264b0mr94774285a.80.1783718049159;
        Fri, 10 Jul 2026 14:14:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e3083sm50604746d6.6.2026.07.10.14.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:14:08 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:14:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Abhinav Kumar <abhinav.kumar@linux.dev>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 10/33] mm/rmap: rename anon_vma_interval_tree_*()
 params and use pgoff_t
Message-ID: <alFgm58E4G7hWIm_@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13A811C0005
X-Stat-Signature: bxtkx66iwchumbcrgxg6whfytooktwa7
X-HE-Tag: 1783718049-973659
X-HE-Meta: U2FsdGVkX1/eLjAkIt10gftAU3YmOXmeE3DI/qanY9DTZ8U0oJ8lvMhI+7a2cx2TELV2TNM2YQq+TQcTKT+HINlw/+1Zmv/1PNjwcIigX4hl2/oPLnjZvRCOC6L1vTwdGnVdK8fj4hfhPffO6E51VUTCxzunuWDAyB9sCaXDzbdKuHg4A8iF59kB5c+wYk8P7Okupw52GKBXkp210toxD2ICwI4TOCeguWZpFWe3698XD7kqQdPZ+A+gvJCW6Om5d+0NHStxkJx0yMLlNtizwKsk8Em6vg/V62MlJMNVkJ0HaqKSygQBWJO50ngvjcAzv29BpfoT+dyCcechY0Zc8z344AHAYDuYL8iyBvpzkASVo70OUOa9Gp3glXAtp2Zfg5tfGnPgbcGWCCsXC+zGj+/yOSA6WY0ve4iv5xVnp+00V/T4/3xOFFLzUnlw5IWgqhjliJsq4BP0ptw6/kmB3HQmefpG7kU84aXXNbjjS/6mXEw9zKJ/uJXF74msRSiJRvw22ZvpE+Qppy/gtgIl+iYOunB33EHslCjeeY6rDaXn6bU6eb+H+hxbHJxIshgEOHFeJn8AkTXYS2q34t6mPM6ZHCRq8tCrvBlLubnS7V2tVHwXMzlteFMiXOjuZNfozsunQXZleCK4KacyLYVrzVFVE5oEBT3GtqvWobLzphl9eFisl6gs05tO3VOziXRojg0N+vIG0y4Kh+R8+r/jb46ljbFYkZNBRVf++2bs8uCZ7LQ+EomKfV10wtWWbXs0WgQqJwHIuFfrG6du9F7fVz/EulINnh0p3ChX9b1w89nSfnRBW7sZxGjOfgtmyIbVPZ+7IeV2l3YuyQQ7UdFP3yhx9SmLmWPBIBkyjQJKLdSdQxf2dPpt5BfPnpu4O0/sLT8WIj3DNsNl8Ie3KWAzG48MisXF81QmGzN6K0kyJq7nN3zNvC16d1Ezo+NSjOJjJnGQHCdyHKxZqTteqMK
 7NpW6rnz
 qH+6eci+4Vrrk4dDgtunzmErbxCwmy3kf+L2u6kNnyUKvQS+OUL80KwWsbdobmlmq9imksYrdD7t4lF8PcFtBjK/AuxU+jpoAVImJ6+t8MlYLpQnbbpVH2CKjFcFDvDUCLVkP8ldZ18wrR29wSxC7GwJW27UTy6WpaPADumpsC+n6ZVJJ9iUebCHtVR4oDaQxpzdRb5PQA8B+WKSMD5I+PIHrXnrq2GWhM3if4EU5h+PTRz3DNXRPG+lOE8qV0wPcQuXj6h5RVjtaDknsC9oxvhIT6kuyGioVoZXUZJLSSXQtXn2vxZA4K7MU2/76V60qZmjrU1fiSafWSrT4AVT0mNYLMpceNJBSj5M89ffaXwU8Xylj+CTgn/hluoXl4ONYwA0x1MGYGFOj/KNWy+yKWvkR6efSDKi6bQjD4cvbbvnQbXll4tms5uWUU0u08UMs2JjYRGyrG5+zZ0yXdsefDxwvNyR19xvHUqccnECNXZUAUdpPmv1oAZntTGG4wUl7lhstCfVSePaPmt4lMlTj+Ko+XH0bKdu05h+AKCCdxWOWHVGiYrTujckrHu/5rPiJXtSW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:16:51PM +0100, Lorenzo Stoakes wrote:
> Rename parameters used by anon_vma_interval_tree_*() functions: 'node' to
> 'avc', 'start/first' to 'pgoff_start', and 'last' to 'pgoff_last' to make
> clear what is being passed.
> 
> Also, express page offsets in terms of pgoff_t to be consistent.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


