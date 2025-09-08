Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F49FCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 05:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1FCD8E000B; Mon,  8 Sep 2025 01:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8AB8E0001; Mon,  8 Sep 2025 01:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97958E000B; Mon,  8 Sep 2025 01:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 927D38E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:58:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 388ED14096E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:58:44 +0000 (UTC)
X-FDA: 83865028968.22.174B11C
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 55F73140012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:58:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eOen8jGc;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757311122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQAO53IheHXnk98zkGI1Xh1RP2KJZB47OD8cVlZVsiE=;
	b=zTElmABLDg29A3bn9O8knQosDm8xXLp4YR9s9/S68qNH9xxa431pc2cmYoIxEm87E7mBTD
	ZS8ZoZUXASF6TRGyODggbWSqxXcb7p7t7aNmHQiXYumF878xcT/kaacC+mL+Z1A2yl8qH6
	SXi1TTFkiHBwpD+rPX4hsVgMli7jL9U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eOen8jGc;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757311122; a=rsa-sha256;
	cv=none;
	b=NwPTpDPH7HyRfgsbiA0jGFHr/WDq9mOXeoNUA/cLcZAWj3NaABZowmcsK6ihR5WQQrXNQk
	AA2vdD/emqu5EnV1eSs2aYWZGYmnGGREQt/crs6mvOoBSK5e7hPKWJ38bHvGS7XF02i+zs
	kC2MKNsUThBJDw/eM4KiudDnLmRR9VA=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24457f581aeso35451995ad.0
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 22:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757311121; x=1757915921; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iQAO53IheHXnk98zkGI1Xh1RP2KJZB47OD8cVlZVsiE=;
        b=eOen8jGcDT2sK2IM95g45b+sWySwyGA4OUHvbDa4pMSVxL3keG5taRi8ZwDtXAfsWC
         5dtX7LpNUV6SOASVVUGtpM+COUe0UV51Ojn4fMC31LWn24iDzYhZcl9zE1FnJ+Tbp/pr
         QsjJYeG+5ElxclKzfgFtrAv5z6B2xeAyTkV8jp2zjpEFe1cvZhnVetDel2FOt2DPsGNd
         DcpSjseUgyyhL9u7f8C3Wytj8PC0G2XnIqjUt46iyG3ghvXOESLar08aatPiFEISPGTb
         bw4aX9PWfBi2G9NS775xWGX4aXPsAXW/nnc7Z+PMT4jw3ujG8ElSBhLzdi2VnZkDp5Zu
         OfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757311121; x=1757915921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQAO53IheHXnk98zkGI1Xh1RP2KJZB47OD8cVlZVsiE=;
        b=tJ25NbOQ6bkSNYF4eoT0uz46GQyCKEmiOwUQ8g83/Jzcu2FguMARrNoMc9EPmkKbhf
         FI0SPVPvFe/tkZuj9T72b2qs8jnci3EuGkE/zHd9eq7bhTVz5bXzjLKdrSdTq5wd/zRe
         37Y6bVm3put6ndQX7hRV3iJkuSq4wlY3w2wWoWSuY1kIBVxF/AiQ+vIVDVNaVvBNitwH
         D+UQ31af3O6TtTyYdlka4+qLkTGdiY7Y5d2uvOvTCPI2GyQ+sbk1PIduXO6R4qPyU4fu
         XIE84e3ijO2LyREUz5ds2tHvlapbg2k6I4uEYYB5uD09ByR0nr5fIZQNpOlKxEQPtmbR
         olFw==
X-Forwarded-Encrypted: i=1; AJvYcCVAaUKkaVnZVuNeAf1Cx4D93UtD4B9WkceCwnAxlNhKrFIfnP1RaAbJkcKoNTq8f1jF8Hv+h6f/Zw==@kvack.org
X-Gm-Message-State: AOJu0YwPPsJhHaWBlPEe10oZzvkcvjCvtgyh5zAEVyKEyWcJ9rEBWjt2
	9avhNRs1CYRdt+Qq9xYKMlFrrX4sRv3D0KjkYv8aPoj7agYxXz0sKjIU
X-Gm-Gg: ASbGncujqjw5JsOTIRnZxpqi7s9Q6xSjrgvRtJhtMqHeSBvacQAR/jJmHCpPw61d8mT
	OijDEn3n7NTTf11staNII0Z5O+7f2QlJwRcDo5Lqr2UtoN7rkxsk9WhXAUnqUaBJhNnQegIE7Pm
	2KkexW3Ip872H1Iafsb5aZPco7/UToO4olTtcBh/Fsh/kNp+5bQSpzgPREVlqXB94u+roKARSuy
	1aRi5rMk+9MnIPritqPDgDfOMndK+WGySNif7AKr3pNjXmwbJDrs3TZW5K54zcQCkDdkLbq8Vjt
	7dv8sPi51mOho67jxX9uaUnulPbaJvsu1BG5YTYg8nya4Ed9fpCB/mLkvBtXLKOAbwhXB/8sgFJ
	eLQ6dgveWMUmRIYTMqZoMGHJvJDR1cJ4NxLQCNw==
X-Google-Smtp-Source: AGHT+IGaiMNB6Lomn1EdvRMYhV/HuuA9G/CRJ6puBizE2rFoQP4ulL6/ASUcZpM18sYQgH+KakQyOA==
X-Received: by 2002:a17:902:cec1:b0:24c:ecaa:7fa with SMTP id d9443c01a7336-25174ff5d11mr93448985ad.48.1757311121081;
        Sun, 07 Sep 2025 22:58:41 -0700 (PDT)
Received: from localhost ([103.121.208.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24a92f89809sm236444905ad.2.2025.09.07.22.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 22:58:40 -0700 (PDT)
Date: Mon, 8 Sep 2025 13:58:37 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/18] mm/ksw: add ksw_config struct and parser
Message-ID: <aL5wjbUYp3_qObzt@mdev>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-3-wangjinchao600@gmail.com>
 <aLlD-74aBdb-ZD5K@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLlD-74aBdb-ZD5K@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55F73140012
X-Stat-Signature: g35grnciy8qucqzt7dwjnhk64gyerd5j
X-Rspam-User: 
X-HE-Tag: 1757311122-637799
X-HE-Meta: U2FsdGVkX19iV1CpGg86eUjDyi1YAdHnp6BxoLqfhWp/6zizCbmn/oY+ty5jgFcxsYv7vAuYFqWtRRpqLt6xRY4RETz9RrYR16vydZ+xysjJZddOVMzyICgiqH4S6uvJxUTzCb8bDF7OOttstvYUE8oviKnT1pwXwAYBhahNpaF8yDDaK25lc/u+z1F4QepQPKzZAyW06nrVocwUpPz4+X1k9QMW09G7VfL3nWtYHTO54VJ+DlMJ+cEjxakm9QK95YnCjAOhNj8lo65Jm4RADb61/vOD59hgJ2Jgo9bFlWB/5hl8eDvVoBaGTp8ciGhhJey/cttM3b14pW2CaB03rqLqNXbafDmUb2301OQkufgjksv4Gw8yy+YHi8ibZDYi304AtA/0/dVpkuCvyJkW6J/qZk0GgB3W/UYgI3ete6jKR5feZsTZErHogGZMbftF/1Pu4ii9ox47SzZzHg1UOiceTnmc28hJhb2zzcA0zwA2tIKh7kIK+M7/h5No9WM7oeRixgvv3axwX/AirembkNauzO3ttZCDiOof75HT4rOfP9GbtVrR5CDNeI1a/nnrrH5PYVMfiWpkT2iZXoHTMPVq3CmzIM9uBAeftojTJMAde/rF4RA2qqzHC5i9PjnljwiM6JS1Yl9m5rUvqirkrVeSp+gD8Biad1Vu8Mm5Tf6gZSwAY3oxDe5OiKavO8hxpy4qy2LfaRsFxH8O1U2w19Q/eZ0acXG0o8Ck+c0hmXQ7f41IIVamNoh2xzEK35A0sOZKH6eOyVoWC3BCyJyd8/7qXLw01fWBtXEU/t9rKIrq6bWhSSj08xWwVAvRSTEyGmt6QtVvV4SWR0nkINXQ515pPox9IujMOUibvneqjwp5nWYKOfZoneXl9mNoLvBNY/buAg23IMLVl93PtXourWz8oCwcSh39aMp79R8NnBvP1q/GEIbQt+F8xt7ma+Z/UcFJJ9bU/oy4XxhfVCw
 pGXc/PL/
 J71KB4RVaHABbiDCyjPmG7BdxVYk+uwytmguBYiam/ielOkTdIiWwAjt8VTag0u7esu/qml1U8ci8hT/6tYUOIeXvaVK07otjXykIuEI8rCXLZT0cUuIxaU5dpxt0Zd2o2twYKQDB6GMHVAMCXAx/N+8Etk4CziNKUCrIbEwfLhaD2wHMx8pglaKR1HlpT6z8PTDrKTnOgHvPT/+kJBx3HPzEQm6cyJCy/aYiP79KXt8Pt7K0lHHef9/TnroTvTGK2i65DtiOeYxrEGMY0vZUE+MEztuIsXv9s2HWxmM6sgYrqT+zCPtirYcXoMKsSP9tyah0m5uLhTshpoSTay45kIfQs8lBJntLn7fXB9PcN2/YcU18CUpZwiMPSlmIN69h93q6sZhQuEdFqq8V2cCVIDIOJdGTvj9Gdc7Y/jH9qDr++GQL4mcryvwBhfv9uragdTosfvK/efMc8/u4LiMBoGbaslOEhKo9X7512h+zxf7/v1jJ1IWNW3QM9UJTvfzpPBTAD2sS5aPHD3Tgnx6xt+/1Cgvg5FCCGGhVwR/vAlkzwVQQSWNfFEzIg6Na7xFJSYk9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 10:47:07AM +0300, Mike Rapoport wrote:
> On Thu, Sep 04, 2025 at 08:20:59AM +0800, Jinchao Wang wrote:
> > Add struct ksw_config and ksw_parse_config() to parse user string.
> > 
> > Update `Makefile` to pass compilation.
> > 
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > ---
> >  mm/kstackwatch/Makefile      |  2 ++
> >  mm/kstackwatch/kernel.c      | 70 +++++++++++++++++++++++++++++++++++-
> >  mm/kstackwatch/kstackwatch.h | 34 ++++++++++++++++++
> >  3 files changed, 105 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
> > index 84a46cb9a766..d422f0e114dd 100644
> > --- a/mm/kstackwatch/Makefile
> > +++ b/mm/kstackwatch/Makefile
> > @@ -1,2 +1,4 @@
> >  obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
> >  kstackwatch-y := kernel.o stack.o watch.o
> > +
> > +CFLAGS_kernel.o := -Wno-error=unused-function
> 
> Can't you just add the function along with the code that uses it?
Thanks for the feedback.

The function ksw_parse_config is called deeply in a later patch, so the
'error: ununsed function' would persist even if I added the caller now.

To keep this patch clean for review, I only include functions that form
a self-contained unit.

I will add a TODO comment to indicate that the CFLAGS addition is
temporary for this patch only and will be removed in a follow-up patch.
> 
> -- 
> Sincerely yours,
> Mike.

