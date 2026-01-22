Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A05D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797546B02EE; Thu, 22 Jan 2026 13:25:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76EF06B02F1; Thu, 22 Jan 2026 13:25:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671A26B02F2; Thu, 22 Jan 2026 13:25:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 541516B02EE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:25:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0911DB9956
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:23 +0000 (UTC)
X-FDA: 84360427326.28.ACAADEA
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id F27D518000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QLOz7zvu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sfl+s++fPRdzTiKMIVj4s7ehxijfWuV5r3RCr1G2vIk=;
	b=YAAav85oXqa7KiSmjLh+4x8LbzmKPz9gvzV77atlbSQWFsVFIOn2hJRhwHZGxuZ/QoX8/S
	d27OYo3Pm5clJk2zItvNlkNa/PzdKs7/uT88FeYu/h/F0AJwk7HFaUck7az4sfUtfZB53D
	9FyLBzQqUJFHDPBiTQus5JCF4fFR/6o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769106321; a=rsa-sha256;
	cv=pass;
	b=JD1mOOyY08pJU9w640vwugS1Gwo1f8FWItB/zoFq/2KIYEffAKHUcsUC89fEMqekSlP4IM
	mgrkEQ7oGjZjD2e/KBJZTuMQHMC9fHeDuiHtioZ/A0hIfQzXmg8f2VJMoNi6gFK310jmJ1
	HGwDiHLLMcAHtTyTO+bi4iqSM1Ci36E=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QLOz7zvu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6581af9c94aso2713911a12.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:25:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769106319; cv=none;
        d=google.com; s=arc-20240605;
        b=WfSsNMJyHAIbXBbbPapGlrTHvFRZnHMIwRkZSvIRc3Si3ooHgD6ffRYIdULVoXyg9E
         Up8/JuYb+HT2MpIQU3LW/UxquK1oYiJztHruJ6SHBGue+3Jth+nAGxE5G9ksuybNGncX
         mBFwLjHQEFrvNm0I+zNk62TtxdungJLo1oKGgA2bq6X5cW4w38CXAZXv+gGkEDIwdaSd
         ExpwV2QTzzjk+gwO1oiMQVGhGGhMTqXyWYwH8pOxvfD8ThJLQxQDNXRwAu7j5xtW2zCL
         b6AmazXA4LcPB61BDIU2hrCxqBU6K+kudyQEJM1ugmx49fXyWbloHTgJl1cuffkvm4Ac
         0KMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sfl+s++fPRdzTiKMIVj4s7ehxijfWuV5r3RCr1G2vIk=;
        fh=a8Apwi8hvDRjhvcE2frGdPL8g6aYC79bqY3R/R7g2Jk=;
        b=jb6OzeAuiEhdhf+FHAINKaRndZOnbqHJWwTiHV9DVBVDe2g070PE5di/CLgaA75cbg
         MXiVF0wWOll/13bENkgWVzjgO9oW7IfPoIPTvNDmLhAIi5km2DAULPxQ4D+nIkY0hh5q
         NbWVPyuJhlz9x+yyTTURLjGHupKhARi1IT1NpSrzkFLvDlzlgRRPYPHrrjoleXDfcAnj
         LPiDpNNZ9lrnfoiM0DTyp2GRNYZTCJa13wjsmmzlVakdX7NOyzbCneO1bAQMTjk8NCzz
         c/eZaMk7aE5duh2DjEOhvII6GFp0iBSkdfHRns4aRTLyAbdWpeTvWp2iHsFDhvJlDo+h
         5rPA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769106319; x=1769711119; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sfl+s++fPRdzTiKMIVj4s7ehxijfWuV5r3RCr1G2vIk=;
        b=QLOz7zvuZLduPC3Us4mUPZ6rxR/s1K1m8w9tNp5pb2uL18GVnbFtEbSY1UTHWprd9x
         9QsTelDX69P9Darw29We6rl2wJ1oqfHPxUzIX6JQrsnrfZpR4hfgX1LGOU5ro8lxJeJ3
         tjCumOXuJsaKR9fPu6QBizOemyadgNFFVSldMBFWpWbIgMwSOqJ34BtuRAKCkcwIZ4bX
         XNH6oYJIE9L2QfRFymrTJrn9eispNQFvrQij6o9J5g2SswZb52pkO3gWE1zmqPneJYLg
         5N3n4W7Tsym7I+SMpSbJIjM5on6uKx/iiiMq/QTTYRSi3MuMwoafF/cQFIPmT2o4RCgy
         GB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769106319; x=1769711119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sfl+s++fPRdzTiKMIVj4s7ehxijfWuV5r3RCr1G2vIk=;
        b=ftSKypnaQ9gg70T0T6BSaRTHaBw6yKwv09wPhPaZcjQiQvcTBYr4zVXTYAXUpW0GOy
         zEcQ2pbjqXFnQgMYxX7LSQrtzWKzRfB8wYczhJFfwCtq7R6Y6tITBEs+rcrpjIMYgPpk
         pUPAV2wiXAkJqCy9KwSevzyWhzYIs/bSMVKE0zcW9EnASw+6GatsjiV51EDKhE9QTlNT
         46uh7E+Cyz+yA2KtNZToT19px/Df3x/lagqKHrHUfdE1kq+Os5MUUf7b+DZGk+BXo+dt
         +gihMcpaXC0z6iNXGZ8SgDP5tiP95p1TCBZ7jAXf41+bYP3/TGSbJJ08zdAjsYZFq7Sw
         OVuA==
X-Forwarded-Encrypted: i=1; AJvYcCX7K1Sj5Cn6K+HN67gQIyQCNbUbbqn6F6VXQ0Rmw2Y6N/0cNgLxWSPO1EPBAuJ+JD2MUfOdY/kRnQ==@kvack.org
X-Gm-Message-State: AOJu0Ywf+MAP8UnLwyk+wefZovCEoAMIuU/vj7Y6cCOdRANuCGnkxiKO
	78ktpVKDrEIJixDSlEbCe/Rw8RU8KqDDaKavKdEZm+XGdI2I5PuSW9g9AvbH8uzxmKDxCR7n5P7
	j0uXTQVC3Y86iZK7ChhTRoyk14vp5DuVzhVa7/Y8IQQ==
X-Gm-Gg: AZuq6aKWG+8XRJi6bGaPm8qmONQBj56Q7CmlUhMKK70R/jyTntqNiJ+G4r+pLIk62VP
	oU2d8lB2kDl+PcHlMao0NMVBkAw8PBgmY0bmCxEm7KNhs9TCH1kb6ZatGj+FZXC/BVHoAreywhf
	Lb/oIeWr86ia1bQvPi5gTNowlVNB/WNN9AHLGJ7tl3XsWmALEwH5sFVPqsGYX6NNTRFSZTAeN7k
	Chq2Nfh/qPT18FbZqRANCi0eiQZvzMGF6kWo9sLPoMHvp/GK/SgUBMle1ZYznzXBty6LbnXJXw9
	iU7MMroAdGkSxQ+4l1LIC1sYqg==
X-Received: by 2002:a05:6402:5202:b0:653:ae75:8d71 with SMTP id
 4fb4d7f45d1cf-658487626b5mr327872a12.8.1769106319440; Thu, 22 Jan 2026
 10:25:19 -0800 (PST)
MIME-Version: 1.0
References: <20260105165839.285270-1-rppt@kernel.org> <20260105165839.285270-6-rppt@kernel.org>
 <2vxzy0lscks4.fsf@kernel.org> <aW_Mqp6HcqLwQImS@kernel.org> <2vxz5x8wcdv3.fsf@kernel.org>
In-Reply-To: <2vxz5x8wcdv3.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:24:43 -0500
X-Gm-Features: AZwV_Qi2mnNh0d8uhfT7gi820V4jZHl3-8Ga9SArfokbd4YKFntrUQRwEGR-uHA
Message-ID: <CA+CK2bB18ymLKh8YAyg8O44j5-7ttAfKC-Og-XMg5KQ=O_Xhwg@mail.gmail.com>
Subject: Re: [PATCH 5/6] kho: Relocate vmalloc preservation structure to KHO
 ABI header
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F27D518000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: acxbrxidk1wwq9bonopzknfh8q81p7pf
X-HE-Tag: 1769106320-19870
X-HE-Meta: U2FsdGVkX1/gaM7VaNGWftSTNt98sRKH+L+en1JP9yERpR3ooleb5ABLwutyF6Ebce3iG/MLvJEEApdeE944iAafQosYYSPn0T3Iwlj8VNLQx0L8T+PsW6fuxLq//88SYapAYbZ4LBdXBJhKBYbKKHFFSH/pFsJMV1l7YBi4KZFXlkftEYwYc/g8K/5e52VY22YkzJp56dumnz+e+CgMSzfS5eTw5f/lL7jasYi/XHJB6CaW4Sbz4mGLMJtqMzbMzSUbkCJycQScRjd3G0bDhPnBE4xCON0S76tK64AwwF3pylGLNSykXsixdMYTu5nOOr92f9yXERvy5yIkHYj9m1eGUkbF3+zgLAd+wYiikOZXwuSfNGRZ2Un++zQFdOMftRiA+qg0K3kIgtK+Us2n+kvRrtFmwswiUxQ+LmdAi7jXcYXxq8sabtziD8OlLZhtZxF2aK0fP9t852YwXnTncaZWTlRjuyzSfcYimHIrNg3YyRt6LMmZX3YaPYPVfoFXAT07sOoNn57faFO7Sfe69bd1qqWyze88QBenB4UphUeGOSJo/RIbfRReNgcj2ZoJe7EzutfDC2keDUOXtKlvN34vc+BsJ5qoqXuGeAp7i6AwDSQ+dq2mNdQsIW4Sj2DNUr+sOpknOwDUZbx2pc7oBnisJYdQu6yY9baYxZ1xNKX3J6hllxIEv56E1/Tawb9PFwGUJoACeHDccuXbnw2289mNDBDf1PY5LoaGLb0gUMbuhAmJeiV606wSTJvggs7gnFeqiUEk9tmVLGbKgHmQ1Aem/+JNQkpPBWI+maUA8BM3xkjy6uA8M6prC3HNfGp2VhCxbIqa+an+xQnQyQ3C3e+qA0U13q+ZRr4g2dVkcR2ZO0Fn1aX2uFN8bXJL1uTy9kOZ96Q0QoamuP09UTPPelHWgEwQSZFpvyD3GH8jbKFkvGfqxsGyf3Mq75v4LNWBqCPkYiTDlznHrqBdk7X
 58NAqU4h
 OJGNpkIDuOMfSOChDIQQfo4xs7Hg61zrhhb1C3jXbh6LxF5KL2U+KV45g55Ow1uRpMZkVlA8PAV4/uvKJA8tl/Oy9tPBZpTCMnNIraJ47VOFaeif8qeJhpuaArsO2wVM7jv4PZTaT9chSaawMytdSQS5YEgGSE7I/Pk/9n+PD+1Ulcg1txtFCnexNvpdpyB2/IA6els74c8XmfAB0o6Qj/ZVSxcy8rX7BH7lExS/Jws8OPKaI7J42XgPznc4vDF/Msn/Ryd1rzj6xkRVYsLScTPX9lnrcW6F4ZpgqZpcfIFSYIR7cUc8KpOj1nmeuU7xZgs8PTVVE9hyE/rO6f5dH337kX4wI6OpwASmsm2s2bnNJSmgcH+9JpOKEc2zXjK++4PsJ4P/cjZmjVSZJyRyLhqurM+f3fIek8DLGBz4MJ3Whtso=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 1:56=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Tue, Jan 20 2026, Mike Rapoport wrote:
>
> > On Tue, Jan 20, 2026 at 04:26:51PM +0000, Pratyush Yadav wrote:
> >> On Mon, Jan 05 2026, Mike Rapoport wrote:
> >>
> >> > From: Jason Miu <jasonmiu@google.com>
> >> >
> >> > The `struct kho_vmalloc` defines the in-memory layout for preserving
> >> > vmalloc regions across kexec. This layout is a contract between kern=
els
> >> > and part of the KHO ABI.
> >> >
> >> > To reflect this relationship, the related structs and helper macros =
are
> >> > relocated to the ABI header, `include/linux/kho/abi/kexec_handover.h=
`.
> >> > This move places the structure's definition under the protection of =
the
> >> > KHO_FDT_COMPATIBLE version string.
> >> >
> >> > The structure and its components are now also documented within the
> >> > ABI header to describe the contract and prevent ABI breaks.
> >> >
> >> > Signed-off-by: Jason Miu <jasonmiu@google.com>
> >> > Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >> [...]
> >> > +/* Helper macro to define a union for a serializable pointer. */
> >> > +#define DECLARE_KHOSER_PTR(name, type)    \
> >> > +  union {                        \
> >> > +          u64 phys;              \
> >> > +          type ptr;              \
> >> > +  } name
> >> > +
> >> > +/* Stores the physical address of a serializable pointer. */
> >> > +#define KHOSER_STORE_PTR(dest, val)               \
> >> > +  ({                                        \
> >> > +          typeof(val) v =3D val;              \
> >> > +          typecheck(typeof((dest).ptr), v); \
> >> > +          (dest).phys =3D virt_to_phys(v);    \
> >> > +  })
> >> > +
> >> > +/* Loads the stored physical address back to a pointer. */
> >> > +#define KHOSER_LOAD_PTR(src)                                       =
       \
> >> > +  ({                                                               =
    \
> >> > +          typeof(src) s =3D src;                                   =
      \
> >> > +          (typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NUL=
L); \
> >> > +  })
> >>
> >> Nit: not a fan of exposing code internals to the ABI header. But witho=
ut
> >> this the definition of kho_vmalloc_hdr won't make any sense to someone
> >> reading the doc without looking at the code. Dunno if we can do anythi=
ng
> >> better though...
> >
> > These might be actually useful for other KHO users.

In my view, khoser definition belongs in the kernel implementation
rather than the cross-kernel ABI. The ABI describes the preserved data
format and should be independent of C types. However, this is a minor
complaint compared to the overall effort of moving the preserved
format into the ABI and making KHO stateless. For that reason, let's
merge it.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

