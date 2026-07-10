Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C93C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39CC26B00BC; Fri, 10 Jul 2026 16:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D276B00BE; Fri, 10 Jul 2026 16:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214B56B00BF; Fri, 10 Jul 2026 16:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E819F6B00BC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:49:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 996FD8F9E3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:49:07 +0000 (UTC)
X-FDA: 84974056734.15.18E4443
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id CF5701C0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:49:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=V0hp4u+a;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783716545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fM3Bw1AZy4lAkPPHaL59OrI7vB0RIP/keCGdI0vS7tk=;
	b=EsYUb/RIOfBK79XOVMcRMnjQf1q0aJs2tKoWDM2pO693Vs5n4G3TO9qlQjOt+9GJ9HNLwF
	+5dpGip3Of739yglA29Mpln3IN/MK2ZusRIM+H9z3cIhtNJb8CAXBL31k3wl5Uqu6YLZOg
	lH/Z8zfut27NHc6E2Oy79g4S2brW2h4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=V0hp4u+a;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783716545;
	b=W7UXovZF3kbBVfDk5tXRU0E6bDmaXwUhRqqta82XuxWZXJUWQ4pAGfkAMXJI64jdZ1VjEt
	IWhxnCAlQ5/jNA7yjbi8eTWZb6Czwm4++VGHePpL0dbHx2AmIqzuHVd+7fH2Mi2TvkPU8f
	BEBtKy8efl2FG33Dn6ZkMp015cxnGxY=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c8e2e39easo10028541cf.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783716545; x=1784321345; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fM3Bw1AZy4lAkPPHaL59OrI7vB0RIP/keCGdI0vS7tk=;
        b=V0hp4u+aACvPz//rmekd+Wtesla8x2RXKVzYJV4kHSEz+Jq3zdLDTSs7bv9X2Bcfzv
         1bXEzDXION72TLWbw873ldLZgUnNOH2l1vguoge0yYCAeYRj6bGaVpMTsjO/Aw2tZMBL
         qSJNX9YzkQGRuPw6TRgo5w80+HhlEK5MlEQXKxjgodn+79KTcfa4hdliTaOj5KpQcAbT
         gkheiQAylNwd/7E6s6IETllLyzHsyYIqcNa1Ph+SQe6rU1Y09MQiJ46lVszjnq1iv7NC
         62vKcl28b0WhtLhHQSSoO47WeDtuSeE7n9nkvWuZ9d1kV9B6SAd5dT+tnVwz+kuEq+iV
         dPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783716545; x=1784321345;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fM3Bw1AZy4lAkPPHaL59OrI7vB0RIP/keCGdI0vS7tk=;
        b=HXSLYrzjELje1Kyx+L5YJXV2aAFWfYbwRjnX1HsIvBEQ4UTKutpoJ3XoeXSqkrKrtM
         g9xFW4klnko4rRC4zJT1LMMspaz4PtVkyIEY77vdbKMEu7n/ppJ1czj1q4mInRuSiu23
         hYIfFFsqQzV5IZUozqlIk/YqRFaToCkPFjHBoC7iUC/HmbJPeZoiVtieNXU9oRZ7jIcd
         mMgCp6aRDSAmDvDG0W154gBckeEI3ic6TCoTVQH9RoxMUBqyEPRVrD8qTAVws9PJjQT8
         7Tya7QGPjOPdUXQMr4ArTcdjk9PtBVr+q/TxW4WS8UEC4mtIeVjbJaTENXhoK6L6hJ8S
         W/SA==
X-Forwarded-Encrypted: i=1; AHgh+RrjQB+ThTIEyYESU0NDndgO6yEn1l2iWh1qbNWVruk76QL/xns4uiT7vTZEMDq7SBKeYl0Mxw8xlA==@kvack.org
X-Gm-Message-State: AOJu0Yw+6abVSZY9UhuXZ4e6yYum0dlUzFMdOnheV+OdW+HDhKZudvIg
	kSW0LFxvcmRIWPxSMUxMjt7gp7DstZshs4vyIsa21ScCVBevFraN7d8f+ffgGroJSac=
X-Gm-Gg: AfdE7cmZWPmN6LKaeawAiGHUBs0zvyZhrJLnC37t1lYUSv8i9Q8g/vv6DpxUZQDA5/j
	DSkMUw3AOrDrdDUmULxXZ6X08CO8tO+AJggWXWd8+/zDDPwTz93b+FRu2afW5tZTRnv0g1YzRVA
	JbSnjyHSjI+ZZ8L4rHp8fiW4Jm1gQFULdIlo3z80VkFtva/XIzHnM4KedwVWoFVQMRFKjwkDYo7
	LBPiyOT6A3zQpC/QWXLP8r2/I55/Eovjy/lYXNE87KUBJazHWjvbHcOgL0rkqurUD/u73HGzd95
	sxk3FqIZCZLW+LPDfxpQ5efDJNusSh9msPExiQsCnC+LYWQ5j2OncuPGmhHYzTc9f36/OtHixvl
	O0X5ricNny7sBcFRY4K25qYvVtYCU73QY7GK5B0Qg6ui9Et0U+J3TbXCDjnLEmlG2ijWqt81Ioe
	7Lg2syQ/rzAyu8lBnVn61P1PtoqHUjfzuqNR7FI1JtETkFVZGG32XthpcYXP14E/bbxs8m
X-Received: by 2002:a05:622a:15c4:b0:51c:7b11:41a3 with SMTP id d75a77b69052e-51cbf361a3bmr5658901cf.80.1783716544856;
        Fri, 10 Jul 2026 13:49:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caaf5f61csm24147321cf.22.2026.07.10.13.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 13:49:04 -0700 (PDT)
Date: Fri, 10 Jul 2026 16:48:58 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 30/30] tools/testing/vma: output compared expression on
 ASSERT_[EQ, NE]()
Message-ID: <alFausURKttxHUAI@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <432444fa4c12ae1c4047550e2b205d3e9bab458f.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <432444fa4c12ae1c4047550e2b205d3e9bab458f.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF5701C0006
X-Stat-Signature: pu5sa1nfc61ax7hwnxec9z9yhdh4m4f8
X-HE-Tag: 1783716545-909335
X-HE-Meta: U2FsdGVkX1/ZJwGlvEyKAZ/GMePOyEEaseghmcEKPtkVNgJiDc+IJCKGXL9iAJsbxVzW7T+hsAKsoOm2ArbfjXlB8w+6hu3zRr8A4gGFlZiiqrymA8kFiGTw2Y444lGJiHyJwJTB+4QemxdU2mM89CrrlldT1ZXvFxzr9P+2FiN7hACVTSo1ED85KguGT27NZpE6P1l12CKb7VnHu7+P/+3x0dSqfuouiE2Lfzlu/Mn6dzu0U8z6al5zPggB4cOLNco8jOAm6Dw/2MKqXdObmO09bUQJ7RKVqR9DXUtJFntwi0NlCJWHXhvQcpM0z+VeZ6VTGkV+6p6QxMn+nBhoBWH33JTXpWfECR+bcE9QqCCSLXZnWDNxgUkKR9YA2J4F23f7lWPq1CxYtl7TWB0LFX9k+dS0BGZL6mfeTJaf064KNkZJPYkMLmKyKhN54CAgPGnhcXtrQTlrGsApUzIhw1vuyo3X5WqDeGt8xdojh0JAtSMtIVDCHgi+UsyiXOrCg99/fMULcA3+KIFCM1DU4a5YZtip7UhN+rcmx+EKSadNOzgkAOw1kOT6GxVadGTsaqkYF+P4OqRc8I8vUsIpQhaN7HhoKoBjxUIHxz+CEWFpTayZXas8nhgG26UEXBy3kg50JlHseycAM/hr6lFZwOviIUOSOyncbhqamUwu5aMbOuffHNCiHL0IxugOoAW04qMUfb96hkb+LVH+w3bbSO2oVsQDBepdp8sHT8GPXGHwnbwwxU5CGQkG0bhOLE1tlYxz8vDcxJDvmGSk/i57F1XQ2WJCRsNNbpupa3lREKCpEttIp8eoMLLHY2N8Cs19nLRAxXTz2ocdF1S8zGWtG25jDEEOJ3nTeAv7DNFIwXGzT0ucFt2ug/TPAoBNKm4kLEYgd8ofZqqQxu3TiqukC5ocIXt5ZUh9zcJggP0vaeGOfmkYW+M4A5m25K34/cIzeAthvz10BmLu3iqFMYv
 6axmJbhV
 b1G8gZQW9eIQsulMzriolUvRXaWN7vV0MSDzP8rROFHKGNxXDyIBvUXkKfXDHLlBZKqqOrwKCd4WVAHCyjlFnYSJpXWFKR0TRU4VpzEIKmx2kPO7Hd52EwT+j2boizxfJ4uw4qk0NAyXRwBkVkKiqCvLCjP+i25tJqcMI7F8H0gZeo7y+Mj8LMaiHepEY0ngHvIxXKrYslhCjWkCDv8iml1jyOfD0mDhsQ2Faw/xEZKDBXfuvBaPZpmrYc8dz8yaVSCfdpusagSvcpPpyUFrw+LQbmq3t0TIHkLSR3bhQj4lZb5xuE4f8BXe3El6zIQTOLLSsBtb11SffhgBB/N8cl27EL1ilVlKEhvPoSAEghldlm+/XGcDCIs97t2zqFXaIcImkXFBlTbSWm09849B/6MBgSZcmoschprPZ3kDHKYtE7aDw2ZIqrcITCQcD2lUsj0nZeNRzjeg2YKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:41PM +0100, Lorenzo Stoakes wrote:
> -#define ASSERT_TRUE(_expr)						\
> -	do {								\
> -		if (!(_expr)) {						\
> -			fprintf(stderr,					\
> -				"Assert FAILED at %s:%d:%s(): %s is FALSE.\n", \
> -				__FILE__, __LINE__, __FUNCTION__, #_expr); \
> -			return false;					\
> -		}							\
> +#define __ASSERT_TRUE(_expr, _fmt, ...)					   \
> +	do {								   \
> +		if (!(_expr)) {						   \
> +			fprintf(stderr,					   \
> +				"Assert FAILED at %s:%d:%s(): %s is FALSE" \
> +				_fmt ".\n",				   \
> +				__FILE__, __LINE__, __FUNCTION__, #_expr   \
> +				__VA_OPT__(,) __VA_ARGS__);		   \
> +			return false;					   \
> +		}							   \
>  	} while (0)
> 
> +#define __TO_SCALAR(x)	((unsigned long long)(uintptr_t)(x))
> +
> +#define ASSERT_TRUE(_expr) __ASSERT_TRUE(_expr, "")

Mmmmm... macro madness.... I don't think this is what you want.

I think you end up double-running the expression in the failure branch.

  ASSERT_EQ(cleanup_mm(&mm, &vmi), 2)

run through the preprocessor expands to:

  do {
      if (!( (cleanup_mm(&mm, &vmi)) == (2) )) {
              **** first run ****

          fprintf(stderr,
              "Assert FAILED at %s:%d:%s(): %s is FALSE" " (0x%llx != 0x%llx)" ".\n",
              "merge.c", 645, __FUNCTION__,
              "(cleanup_mm(&mm, &vmi)) == (2)",
              ((unsigned long long)(uintptr_t)(cleanup_mm(&mm, &vmi))),
                                               **** second run ****

              ((unsigned long long)(uintptr_t)(2)));
          return false;
      }
  } while (0);


A bunch of existing ASSERT callers mutate state, so there's no guarantee
the printed value matches teh actual test value.

I think you want something like:

#define ASSERT_EQ(_val1, _val2) do {	\
	__auto_type _v1 = (_val1);	\
	__auto_type _v2 = (_val2);	\
	__ASSERT_TRUE(_v1 == _v2, " (0x%llx != 0x%llx)",	\
		__TO_SCALAR(_v1), __TO_SCALAR(_v2));	\
} while (0)

which expands to:

  do {
      __auto_type _v1 = (cleanup_mm(&mm, &vmi));
      __auto_type _v2 = (2);
      do {
          if (!(_v1 == _v2)) {
              fprintf(stderr, "...FALSE (0x%llx != 0x%llx).\n",
                      "merge.c", 645, __FUNCTION__, "_v1 == _v2",
                      ((unsigned long long)(uintptr_t)(_v1)),
                      ((unsigned long long)(uintptr_t)(_v2)));
              return false;
          }
      } while (0);
  } while (0);

~Gregory

