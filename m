Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D3C2CA0EE8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 02:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FD48E0007; Sun, 14 Sep 2025 22:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0628E0003; Sun, 14 Sep 2025 22:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF0D8E0007; Sun, 14 Sep 2025 22:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C35FB8E0003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 22:03:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72C7C865B7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 02:03:17 +0000 (UTC)
X-FDA: 83889837234.14.78E437E
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8FE28A0003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 02:03:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nHrv0fDp;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757901795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOygL22yeiI/c6chOsAL099+jLfX4ygYuBDAjkKbT5k=;
	b=yxcC7H/ahdawDGLTZB4Zfya/DWMIakZQsvGh84vulmbkXfVGB8ZopOH9gGNqhbK47PLazP
	BL8Xm0IdxgGDsGdWoKEE9T8sG7Eqjo4NjPbgkG9GqNO+IHy9JpgglqGrC3XRoA8GZhkrWj
	KcDxcegx5G4o4ZndwDL+JJpkgL+W2LU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757901795; a=rsa-sha256;
	cv=none;
	b=HcjRfycBmUdf7heuWYdrBdCF080/JjsJMaVBS0g+e46bD+udtScU35iRMWQ+v1mudUwGwc
	OvdA3RdmGN4rMEjHtLbLgCmmwfCzHBUlxXaqkpUquN5GxInh9tz0IwQdBT0QjV9L3xl58L
	/uAaD5nKs2yZSYAaLh08yDzllR2j1n8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nHrv0fDp;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b47475cf8ecso2459003a12.0
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 19:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757901794; x=1758506594; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JOygL22yeiI/c6chOsAL099+jLfX4ygYuBDAjkKbT5k=;
        b=nHrv0fDpFjjd6agoC4OkX+NzZ6sBw9Y6VkEkCCXexlzNPRPdjhh3TTb29+zeWesKmS
         KRDnJmsAAr/j1UM3jp9vawy8PTuEeHW5YhcI+0JFAUf5/b2bB33sDygL4F9QrN3kJ3me
         Sn+KmndY2LCCxmxYCilI0xAeJUSBrfyOKPmKV7SyDPKFrt/Iwoalo7V2ajHoq4Gw9A+K
         CJHDH68byxBU1AYOKrTcD8HqhZsc5Pt1ZsQ46y59YH1lDTBfITfrj4zEZ9mw64oYYODU
         wbrmg56JfhO/L/JTo0ijY9rR20QthsMncxQLLowQMWnisYOwWXTL3TyObmRzY+yLketp
         pX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757901794; x=1758506594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOygL22yeiI/c6chOsAL099+jLfX4ygYuBDAjkKbT5k=;
        b=mUtfFp+YVkYp3dWEZ1AZjmBjz9RBLfuX9JnTTWGU4CM3byVWfYUXIfg46zblyQG2uC
         H/GZNHyHqi3EnGNRnkMOKqZ1rpH+VUCZsX/Nc3o6EY1cRqhPpNlwgZHfaO60NxfFxROT
         5jodkZPV2kkTZLjvu75076gvK1WKlo5BSfuPXMs5+ME9wjMPl4MREv1zV3zG1TbcdSRq
         /wE0tM2DGdt7k6SU250+TTLlwdnFi68s1ZBfM/eWx4VKoUkpKXVP0bFYsQ2Xzuqi++qW
         4w9o43jZ+6Vm0CRv4uM43KeH5Foqt52IkEHEJuRCTX+8t9WoRr1rCE6vEioUZXibepIF
         zUBw==
X-Forwarded-Encrypted: i=1; AJvYcCV/2+dNwCdjvQNJGpB8/g0C4om3HWidgZZKtzvc6FJrvegbHuaDuEjJx/DEuvkVUITKpFdGO41LDQ==@kvack.org
X-Gm-Message-State: AOJu0YzGJXW5uJtf958/nxCEbe6a/32qVfdxSjFtYJCCikBfsk+i2TUL
	lGRzkz0QzuelcB5lIX4XweQUsZLyx3yVOWnGbTu2YzNnxAxbNlotiog7
X-Gm-Gg: ASbGncvU30XfZggcD/PM3Qhn85t/hzKEoa2wDZltk7myEvFnhWMNX8MlojQ4ENKleoV
	XXq3ObLoTupmXOD966WUkXfyDVhtfTx7iL3imHSIOMy2CWCSup8u1hTxmI36UAd74U7YWCDY1qE
	skaWrZmWqRwxbwTBVhQzYVvBDfz2EOrfP+S9m0/cDdXWFO7ngoC3FGQTJDRHVbJ7bV9ubEIsbY9
	uwFhqgev2y319f7NkZVS69Sb6965HPAEFOFA0WVg9xKJUEy32Dp5VFh2IbqQlPUjg6tEuIX9N9/
	KJcSWZl81ULPsqlQGdYWkjlo9VRP4gnC/JU7MOMb60wY37wFk4796c3vKcf/6AIyISPmn9oKQUX
	dt+3P6dtVf/KrHpDn0OKTCIU5vPhX6x1IWOxiwF8=
X-Google-Smtp-Source: AGHT+IEeqkh40QJM9zjJ8HL43W+1enVBlgkaCaBCrqZXNAUnxXXVQNA79eZr3zdQ3nIBlPPQ1opd6Q==
X-Received: by 2002:a17:903:f85:b0:260:5bab:8cad with SMTP id d9443c01a7336-2605babb245mr90876965ad.29.1757901794287;
        Sun, 14 Sep 2025 19:03:14 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-261333a972dsm51596705ad.75.2025.09.14.19.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 19:03:13 -0700 (PDT)
Date: Mon, 15 Sep 2025 10:03:06 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>, Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>, Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com, "David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/21] mm/ksw: add test module
Message-ID: <aMdz2gMb5YC3G3md@mdev>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
 <20250912101145.465708-16-wangjinchao600@gmail.com>
 <69198449-411b-4374-900a-16dc6cb91178@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69198449-411b-4374-900a-16dc6cb91178@infradead.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8FE28A0003
X-Stat-Signature: 7b6uy7an6459gemnti36hrgbpthhfnmr
X-Rspam-User: 
X-HE-Tag: 1757901795-420284
X-HE-Meta: U2FsdGVkX1/kwG12AN1Gi/daD3UrBTNMlQNef2+a6fYzXmPPr+ZplkoCyKCrsOhb4giuSe95/7Lb7i7GIF9ipzG91HOe2ZNZ1weBC/VltfosdCjnGaFJnmaYIbDXEZfQUUO5Hg+3u3iOTiyg2VvED5faEUgZbj54G2ZllOdv2XSYTw0dQVE35uy+tsh2N8B/8g2+UiQYBkQhHVBAkyAvAWKyT93jlx6E5aM/FoBnq1t+RW7SKjZAoKc6qjjxmIuWpT2+FgK37mm6El6ou7GbLP3erH97FU5ktzEzJYebGK701ZJg4Uvw+Bvm/UdNEswN+hje0noEoBW02Nsm4YSC82BfPgpfys2RlYHrZmzwSR8cNxmIy9Dy/+ksbYH3KfQmMHK+KmD9b+nNjGrFzvQUk1gSfpkRBe8m9lD87JQu0xKUCehrwpb5ILLn5Aehrbkx2xgIWOGfwBzd+abOZs3JB8yS0T4f8yKRDVq1lROYHsI3INzIDDcthmUixsaYjB/Ut8of7udLTqqD4e1sOvduGiY3N5HZaIGfkG7j5mTYk+ZpYBIkvuQ7TsWQRpnee6ViGYXN4jAA+0KtLGvPoU8I7nbepUa54Hjwq70u4ZLAZuYGZ3U4zt27U5imrJfMbUH6nSdTtuqLM0tbGvl9K1l5+57VPVIBqgu/l2WjkXTqYhWjmq8g855wY4TeZe2u4LUdC0hvo40B3Ua5JovN/ypubzDOhLSgWF/5fnvwFQNA/ma8pTkg+2a+lt4UN6hLJOvW/mEItekUzyCYLF9eRZu8oFWaPaFI+eN64N7Klqi+9NHGOIeIv/h4tEYS6HIjAlBAMWtKMBw/6cSu9AP/O5U4nJIVG+ya/5ifgJM3rduESR5uG/IQCjtHd9yV1VEybdhYxURLRNdIs+RXpf/jduDQp18jLG+mRfziymL2upZrZa9MqcD95oc3QxMs4YQwU/z+qtodwNinfTU8pQQD/dI
 1o2dVReW
 QReCI8NZ/IT+TluCl63FggYuo5mDELV/3tDIIhf775FZWk8rz0q7ntzd7NVtutOpc6BIcy2aDNrYVsMPKJMLICOmtkiXLKn4C//68dfcNudBx4wnW1FVHCRR1K4YLgkCr7WpRBPK5bGNOOguef+JZ3qj9kn2sH6vhFd9pkBlKcR13JsdNrFKCV8UW9WruAp4IxmCn4a8fzve2Oa3tq3DjR2gYWJpuWFH+jql/yhFnRq13CI1EDGRDUxyQJGJvHw2hRctTiR2FFBgmOR5ICqkxPCUGii8ABlEDB0a/jKw7liaLjWt4BUc5iCwTqvxAr0lmqC4MS+E3n31AwNb1bVBsfh1TJhHc3npdnS3uQT/3Rh66pGSzO7ad1W/YvMppW7Kziq1sH4hbTkmmFYsBw9RZ2av+4ItwwfD3BVHt9FlI7spIeb2cL0Ac3xj/OlA/WDooRKPQ/kSCZKmtnGumVOYxgRI9hXCyWv2MqpbohXBy5aCVIyqh9MXKpzQBhrcQ9fXOyigKTlOxUK+8MAVrE7DvtkGzqwh1gami2eqUmRldMhw7XOWYI0kKTM5LZNBfpcr66vsyJJAxwaYwTuFRB2uZ9IopbxYkpF22sIaJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 09:07:11PM -0700, Randy Dunlap wrote:
> 
> 
> On 9/12/25 3:11 AM, Jinchao Wang wrote:
> > diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> > index fdfc6e6d0dec..46c280280980 100644
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -320,3 +320,13 @@ config KSTACK_WATCH
> >  	  the recursive depth of the monitored function.
> >  
> >  	  If unsure, say N.
> > +
> > +config KSTACK_WATCH_TEST
> > +	tristate "KStackWatch Test Module"
> > +	depends on KSTACK_WATCH
> > +	help
> > +	  This module provides controlled stack exhaustion and overflow scenarios
> > +	  to verify the functionality of KStackWatch. It is particularly useful
> > +	  for development and validation of the KStachWatch mechanism.
> 
> typo:	                                        ^^^^^^^^^^^
Thanks, will be fix in next version.
> 
> > +
> > +	  If unsure, say N.
> 
> -- 
> ~Randy
> 

-- 
Jinchao

