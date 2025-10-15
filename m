Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C7DCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 22:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500508E000E; Wed, 15 Oct 2025 18:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8088E000C; Wed, 15 Oct 2025 18:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EDBB8E000E; Wed, 15 Oct 2025 18:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9DA8E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:36:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D83D811A64B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:36:21 +0000 (UTC)
X-FDA: 84001808562.14.E93A6D5
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 10075A0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:36:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CfmFvSQ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760567780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/s3SxkSL7eyHkb5KLXrWbWzbuM7vlN9wwYLs0WQrX4=;
	b=lzZ2QHkP0MgmHL8KUvXZNICFBthpFDtnbLrQ7hYEOg0XEz3I+s+gCdEo4B6g7cRJemCX6f
	3E4UgJ6tLuhovTrtIwRSoLGB9wHCto/i+N7J8JD5yOEdcxufho0Wb3JpMw205NSAJNvU5W
	xdZyHRi5LueQ0xkBZmO/CTKdK+FeNMk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760567780; a=rsa-sha256;
	cv=none;
	b=viQ8wiEQs3Dhr0lRJ87lEblBet79CHkNcWUogYFXr13834sxfgU3N6omDJt0DWoQhyWBgs
	XaOIasMskoJIFBnGLogo0mGdl/oPiCO2iRfdMMn4MPjSR27pXa58pww86PfHPqIzdiN6HF
	+LveKEKKqEMgIklblGDRADoadukv/Zs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CfmFvSQ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-90a0b3ddebeso3532839f.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760567779; x=1761172579; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/s3SxkSL7eyHkb5KLXrWbWzbuM7vlN9wwYLs0WQrX4=;
        b=CfmFvSQ3PugQr63j8C8cEUMLlsdQV8LXYLR8WxMs1PhL26cHkvh5YjvdzqsB5Nv4nX
         pDseDpORH0jjD8loml3GZ0eT3KaYRIySltBny5CKpF+Yjirqk4l4OFW4xCWcaMQSwNGz
         h/fKWIVjCyvXRx3OP6bJ+0UqifGHBSne/H2xvQcEiGs4omRsD1tjtYvDEWOJagy2Q8iF
         8F3P7GYY6mhLk33suUgocTPkljgg/7BGrTywqURzcpejCjQEH7cbWi/q2EomvfDKBVTB
         FlVHCKF+6sTPw+ydVFY0ICac+kY8HTvt7tgSoGmgRi6/d/RxRN/v1/11ymo5gINwkSUp
         9E+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760567779; x=1761172579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/s3SxkSL7eyHkb5KLXrWbWzbuM7vlN9wwYLs0WQrX4=;
        b=AnPy12zofXxLUmEa5MzH1i9qqiijecFP11AKwZozJTwhS6L5K02kVKg8WBYzoLwhiW
         hIe6rF3oQ144N4jsjIMnVTWRFcBjmyMq0gCvHGZYjtA+oVkum0tpGoKqv8+oUCjoHC+E
         LdGpLtkvDq28sjyYiT8Yh3fqiPVls8gfnTsj1QFqBG4TtdyAZLroGyhJrFcZlueaDXd0
         9Or25pBCnxGgOgcCCPRJ5jmHLqQzOuHkqd8SXJTPHMCItxLzp5ErjS4FrbmkgbPe9s64
         QsNR+qKXnnoM1safWtrG9nM3YjH8pwOPfy6tHLT2ansJpNISF5VjEmhifbuU+9JF856M
         SbhA==
X-Forwarded-Encrypted: i=1; AJvYcCXar+g/W8nxQgxZma5YsRUUBO3/e78LERA392aUJzNWI/JfTiVbJ/ngPG1/0Q/8dRa/Lq9eZblNGw==@kvack.org
X-Gm-Message-State: AOJu0Yz0yR0ttOLpsaeyEQN39hcfRxcAT9kwQR2c5yKbzrajVx12EpDk
	aVDP5f8USDW8LQuyDrZ7F5Ik5HQhQZmW7QwVdvqkDy6vsqc1h6Dbchpdgaqvsa79VnMwUAD3QW0
	cGx8KC8BAgvuwlP/j9afMBdXuxI2bgk4=
X-Gm-Gg: ASbGnct0sC+pck/3cP86Ia8pXfl1FWjiCyIkRTucTQYKChcjgBJvyt8tpfUkC1hsLqj
	gDfdg3oei/7Hf1Opz1w0LL4udaNAX8LkNhHGE/IRhKT2RgLcxZaUdiyKZzs2C8DnsHxEimGsfPl
	7wajCcxix0/z5vw/dPJUJlUVUW4jKU7FvNVNafkHfwE0lMocoEvlhORyjkvpAJyTJwtGImejPCj
	R8zLQe7KINR4D8IL5zjxBa70MqJlb9SKNaJkfjzbp9JqtDy4hJujOCT/CWzBVUhtFu+mCIUujWq
	enQ1L5W3Bys=
X-Google-Smtp-Source: AGHT+IGtboEau6Bk88v51SDez19PVTOsqLfeOAK8nKqy+9mn8xNBqudys2qDDCtNVqCWa7SL4XVc9GvBu99uBwf86Y4=
X-Received: by 2002:a05:6e02:1c0c:b0:430:aedb:3719 with SMTP id
 e9e14a558f8ab-430aedb37ddmr43372305ab.4.1760567778959; Wed, 15 Oct 2025
 15:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com> <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
 <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com>
 <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAKEwX=NkaaCkoyULr4J+5-F+L5bRhM0F8JsV2DS0Mk=xYhncRw@mail.gmail.com>
 <PH7PR11MB812150A977B6F9F68ACDBCC9C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <wn6pnt2nm5pguceiquctilul6lrk3ckycypwnw2zfxqrlgi2cf@5qn32ewswfl7>
In-Reply-To: <wn6pnt2nm5pguceiquctilul6lrk3ckycypwnw2zfxqrlgi2cf@5qn32ewswfl7>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 15 Oct 2025 15:36:07 -0700
X-Gm-Features: AS18NWBiVKuP96cBHxdACGNu0LbupTKRms6mwcpp7-LPrgrL-Jvm71bteOqHTN8
Message-ID: <CAKEwX=NT_3QJSQGRgogGYmx_M262O+F4Hs9BtbCUqK3qbh+t8g@mail.gmail.com>
Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: bgjx6wffftq3khuy1iydw55fpb7c8cwj
X-Rspam-User: 
X-Rspamd-Queue-Id: 10075A0002
X-HE-Tag: 1760567779-892175
X-HE-Meta: U2FsdGVkX1+cHVXJhk3s+eErQhpVSFAaOmYNwgSa5MOPg2dkxaTqyUV6/Qx3HOSirf3zI/AKqV7/uMaM/Jacm0KL/iacLcAIoEA/EQBZ5pwWtBYJvwg/ecQ0PzbXEbrBa3A/ulk+l5VBCevFFpCVlULSkP0GVvAtmJMC3WxDtqSkHZzwUQ2QjjXSY4E+Y2FoZBAixLRUcH7fHDCVtNril62fYzi2N2PiBjcbhzO1IeN3aoLaJk1L/Q18Y70u2Ew6M0n2rme+iUHQuPh44REstI4nR1qQY6VJcSAGQQ4jtAUEdsaHVEqJ+LRJlS9zJ8y8nQKr1Q6IFPeKZpUQkdYM9yUlNAdun5++lex6vbOOsuHShn5Rp6RKNaj34FAWd8DjeelBcyFQi2CXa1ggDSyjaOhNTPsLlX8rU4KR/jB5ukQhC2KAvbfXiX96tVh8/ZVkdG3yfD3awXxAuP1s95Hx9p9ipCNYu8yYUUbWgjSUNUP9W226uTUgXF0ZY6/kVMI+uZ6YGZHr9b/EJigJ8nj1IUnwYv6GGN+azcRIbLfzmOfs3MZzbaor5KtFTIgZUxRjI148zWqOT2o5HeaFPRQrnySYLzAhTf6CIREI25aak5vSqgZYXrU15Mc72Z9YlFkZRQHa0rVBgoRH/5jDAsXiwNTsYPc1cOlV4qGrpvGajaEyhG6Xg28ZuO2Che1+SrBKdgIs1fqRPw3h/gkfeBMWVHk27TZX5QRigDQZ07KUdGwJeRyc9tWksAo1TaiJFby0M5Xn1THaUQq2BSEAz5tZTiMYyTjHrCSe9ZjDAtHEB4wM6XsAwbuOX+v6EvoU9+043KubrnPDRDZflmwqH+geZMISTXlLb43OG1kBJ/V+g/Q3sRrC48uNTmHzzxJgLE+MvGXiI+BpjGmS/aa3AoXzW0JrDmnxHCKgMw00mND2DUBE+e/1P8y5Hc15TGP+XIHtONFYk56K+YoghQQu00K
 TTPD26FE
 bWgvkSHCXMInbPDe+yCwRNl2g89eSPlbp8JYU2RaAyeW8o999ihhc0qZ9DQETiCKaGoTswymOrqI3phQQ8tc/jD7SlL+W9rqS57ltca78Avr6ilnOaK7/NYUate80FZFAzjbzQBO6gZIIT4fbbAlfO6IAjhP7Mzh/yQ/RaICVG8mHynj+FXZ65c6b0BOcw+yKM/G0RXaUo2qPOq8+Se2mbo8FENkU9n3vkjIviKW7HR0aOl1tvk9xIzwFXg891Frr9Vaq3dP9O3cLYT9xRhDoucOejyUkE63HMOZM5R6cRck8YDwLoFg/ME8fGI478xHiKH9KElR/gJdRB9lPIKDaScpXdHjMjksdug4h5/fr2oLudpjagdlyQPFP3v0LiAnWAReCr0DwI8PhNdTk+t1GUMuSG2PrSVicWhEhHXo/OpgDDBoutYY+7givi8UDKkOnzwbM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 3:24=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Wed, Oct 15, 2025 at 10:15:12PM +0000, Sridhar, Kanchana P wrote:
>
> I am against increasing the size of struct zswap_entry. On x86_64, there
> is a 3 byte hole after 'referenced'. We can technically use that,
> although the node id is usually an int, which is 4 bytes on x86_64.
>
> In practice, I think 2 bytes (i.e. short) should be enough, but it will
> be ugly to cast the node id to a short. We should at least WARN on
> overflow.

Can we pack length and referenced using bit fields? I assume
compressed length cannot exceed 2^31 - 1? :)

So, something along the line of:

struct {
    unsigned int length:31;
    bool referenced:1;
}

That way, we save up another 4 bytes hole, which can be repurposed for
the node's id.

Does that work? I'm not very experienced with this magickery - please
fact check me :)


>
> Or we can take the simple route and drop the bulk allocation.

Or this :)

