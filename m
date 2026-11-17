Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A619F606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=ACMxWvYp
Received: by kanga.kvack.org (Postfix)
	id A89196B00EF; Tue, 17 Nov 2026 11:05:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A0E6B05B0; Tue, 17 Nov 2026 11:05:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9010E6B05B2; Tue, 17 Nov 2026 11:05:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65FAA6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:05:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEA431C3D3F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:05:51 +0000 (UTC)
X-FDA: 85445086902.10.5EF9809
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id DF05B20016
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:05:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ACMxWvYp;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931550;
	b=GTAoTQORAOa3HMtobWnybL65wgW6mhqXhlKXgRms6TSCa5x6EqMK4RFsi3ouZgIzNsHAXF
	tD4tcqa3JP+CzW0KnB8OPtN+Vo4pdvhaYAOKTsy8t0Jb7SJCh+6fpu1tPFa76GPMNL/BAO
	CN2IyBwXAGAduAocx1G83/OO2EsoIUU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IG2RtveLbr6LLHiOkKFy7cZt2dAAYGYqRZMKbSVVxF4=;
	b=S3bQoNjh7NSoC/F/dp1rq8SA3N3LgGjvj+MGB7UZxQgV/uktxn4FNZcjue2wnMbS19MkG/
	fujFw+GR7GMtOmYdy3fBTk7+en8705Gpg6sJe30BkrcnXjOYP2a6PlKNG3XN5fZruzlXF1
	vInSJLRPxaqNXdc6Y7rSW9ka83+eShY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ACMxWvYp;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-7cc2bb73cd9so1413948137.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794931549; x=1795536349; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IG2RtveLbr6LLHiOkKFy7cZt2dAAYGYqRZMKbSVVxF4=;
        b=ACMxWvYpZDWxeQ9nluRdfuKUu1RnuGDpqvmhdA+BS1GLgPXjizVnCnxKdaG6T3eUyP
         86FyaV4bmG3TS3BiD6aHP71w7Vg1gD0WpfETZAtMF4mt9FMm79e0dTprZEeHswSmfQUw
         7syZOASu74m5Y6Gd+UDQlcGLZHVd+PV4TY5y10iE9e0TYEjTHjxmigz6BLV2ZRyxjKaN
         NMKn6HLbo7eMsEzq4dXiT6ty9lrRj4w0K1daslmATyrXhqxIN/j/DXLQvdtI3nTDlRZB
         NxFyWxtuAyIQ7dLnZvk5HzwXU1kcCKxHkEgcbF5dzJD8DitJl5MosIRUKe5iWezrlf2u
         EFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794931549; x=1795536349;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IG2RtveLbr6LLHiOkKFy7cZt2dAAYGYqRZMKbSVVxF4=;
        b=yjuvkWIgbG9HNAJltrfzbcQo6hmoxF+5fkeejn3i3sZfbvlaUikbP9Cs3zeiRxr62E
         EkTipVUSFsPZ2oN/iL3eD30jXBgey8FTHniu9/JlrOH98IJeoxtfPw/WMr1pOyWBxMdI
         B9fQlM1jBBlFNr0PwErVjUG4NM6xzxZR08zp3ArYR2fupCNcnsVyoDL++89yZS1Xnz3l
         P2LvPnRsn/xtdMhFfCs7xsK17kubo/BA3wWM54m3nBzcCXGE31CRm1lB2S2BeUebe7NG
         Vg48TB0C5gXa9hJNQpOxDRgt2fj5KF9HKOBux89ww/b4zEqgvx/gEWesRiIJnx8VLpN5
         pTKA==
X-Forwarded-Encrypted: i=1; AL+hErGCLv/488xOv/QDTEGTr5HuqsZinjPZ6JHv7Og3FDCiX3SaH/9swJ9JknCtu5QFbI/g+AQKK2q4uQ==@kvack.org
X-Gm-Message-State: APuU4Z/Of3I+Dc2vwsxNcbsNlfMstMTOLgh7Oi+hZC3WQShuWTT73QHb
	ICIDhxFBtSZlBdHCedNM5uI3xZIzi5qgX3gNtqrrWzQvkaCjEkwim7YRdH0RpXCwJ3I=
X-Gm-Gg: AYBFou2yaddx0I8Ya5AX0/wJY2r0c5692bMEqR7bealgF3FQpDeTbQb8Dpd1qnIK+6g
	oMAdjlXQVZG8ztKdatKxi9hKTFhKb4oOwYF0GZc2vZDpj2f1e68ZmVfn0rMzbnbE9oX8Izf7OJR
	RRObYEggNIuFl0FughfBjI2BYxDoVSZzYWOkkpfGcmFBLxpXuybhjW1UqdKdi/4ctMemdWvtSHt
	HkjcA7FNMlniylSPd6w52RPgLPwIS88P9phrL2PbRQ+SqXuN+5LJlJcd7pAje6BYbp2MaLekUou
	l5C0tXB4WOPhPvexyfCMoF+NAoX+HScyuSCZVjSZ+bOq7/eRuL+Xy4H0kN9weNX70TbgmULLxm5
	nyuc+fsDZheJN6KxZzlLT2RU8CEZUUkO/eGbXpUsIwyu2wkVlmFcB/1mJORF452qLxz7R+C4K5M
	83Foqld4Ls8nexV3sejdTFTEUl5xsNQ900FVBlRCe3cLXSYovbCrl34NjnNuE661VBDy9UC1ukJ
	amrsRC0rZ5WeAYeGlPJvQnGSfhzMhDYmXjn+7LGSZuvu9AW/0bujHWv9lz2OQMmiLc/njIUdemg
	zWFRf7C/O1PEyDgebPxnhIYWmsZSreCNkds6jBWdnW5OkDL/lAWAPAkNYQqs/k1gV5LkiDI+4ji
	vhuxsTBaNlHoOYHgFX0UPlkyRCxk64Bg=
X-Received: by 2002:a05:6102:4457:b0:7c1:8aa5:36d6 with SMTP id ada2fe7eead31-7d64d6d4a85mr3228252137.11.1794931548510;
        Tue, 17 Nov 2026 08:05:48 -0800 (PST)
Received: from localhost (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d69e023608sm2832234137.7.2026.11.17.08.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 08:05:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Nov 2026 11:05:46 -0500
Message-Id: <DMXM4P4NQ6DH.15QJ2AU95YJRT@soleen.com>
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Pratyush Yadav" <pratyush@kernel.org>
Cc: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike Rapoport"
 <rppt@kernel.org>, "Alexander Graf" <graf@amazon.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Tarun Sahu" <tarunsahu@google.com>, "David Matlack" <dmatlack@google.com>,
 "Samiullah Khawaja" <skhawaja@google.com>, <kexec@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] KHO map
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261116134013.1636689-1-pratyush@kernel.org>
 <179486913878.127049.11178890384802388709.b4-review@b4>
 <2vxzwlqbfxtf.fsf@kernel.org> <2vxzpkw3fp2y.fsf@kernel.org>
In-Reply-To: <2vxzpkw3fp2y.fsf@kernel.org>
X-Rspamd-Queue-Id: DF05B20016
X-Rspam-User:
X-Stat-Signature: rt3fh76geqffqsfzdigd15xqyq9tt18k
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794931549-240583
X-HE-Meta: U2FsdGVkX19zPwTg/p0zA63EdFYNLNrTcYOvfqNBqa6Z7cUd+8keE1/hryerG72/HwgD3twosalS1DfswVyFv1E2OYpabPRslDhT4ysG9Fl8Bj7uw+fFnm/xUA/RFJMPg77NwxBRnpra/g4XTwF4BF8/oUwiXfHQPYdsyNdt6skBRf7VxDXOh8cKTa3+fKFTKng7fKXsyzFmTJwm7Ig4KPxvpRYIe2UblrUUQxS7sp/1zV1LMm66KTeKwE/ajI3KHkGtuFhFDRqCwVcszyuoZx3Vgrv7VTMR1SaQKjW827l4PTzeMh9YDGy1Ei6GHRzEF8uPSYbCB4G0PSZ2HZRoRIO0ODcv4AtiC1yK8MRFkBd9X5ID5YS2XxwoNl7sXh4/M7ELXgYjQEwuQMi0m7jNYej90W1r0dSJ+BdODnOqQzYg7aB8Osjk7runmep0mt0Gj3zWWMljVOGZIyApHnOdclJLMbDODQ5KdfVTGHJI7T1mPKhmD4IhZcrLAHF2+6oTMJ+BQTFv1HQ1ZKUdPlQrYYLntiYLiscCb/+he1hwKW0gkZmChU9H1blPgKW9yc5MzpdVi2iRoekXMrMYwSIzMae0Kh3cWCCNPMqP1qkEVE8OY6+r2aTx/JRGnt63O1WbdA7zl1xlj4s3UOTI63AK6aZ8Gsd+DW76yCxnnpmki1l0PoGg9af/Una0vmZOUIylU1y6yfFHqwcvIzjMt0uQ5k/ZvVwyGMtlc7Wppo3gqUFWQ3YF7jmlpZ7CRzQoiAoYKha2uJMunY+UIdzpPzssATrjoxvT6W7+OWaQbPdAjP3CtMIjPo9xUy/LoEYh3Nc/bya2bpdy1KnwO265LzQp5YNKpuErN9sVtvqxSS02dZYxgly+f5WHCFlLQu/zpESRBREPt/dmn6Y9yfePUibS5cfOlYgTa7IY16oS4K3LMWZU7BwdYvaYB8JwiHf0Qq78RnwjIk9r/HzWT390Lhv
 UZhqXx02
 LLp60Uk82v9jJjT+/lG0OmkWt0xHM51frccQ1k/nzTYUUP7voMb+bEwXv5DTcitfpYoI4zZsjLyB/ChsHdSLVUIeT2a4VSQo3cPy1r8Jn2ec/TH/GaY/giTQtOtm/cprIg7XwSHQ9qtvBpZA+dmz1pcAUasQskNxX1WV3GLIXSaaYvidKaLPhTVlGr6XGmQKOmIpULU0Z5vXm++yIIBEgmJTJMfrORgLG2+zDcv+zK4N8PMBW3eZ8BS6Pv/DmBoOF07V+qXMLb1WYi14t/kr64Ss/bhHI6HvbDOKVxsa0V9jgbH0OGDLeFuFzMzW1zbeK3ZkqpCuvg9HWi2wvb8e5AaVGjtdnqnwWsG6Hw9wP0xHylj/3DoFo6r+OiFqOJQa9WIjiuzYwdp1/SsbipS319lrZgg7eklzyUTcGQ+LNKuc6hWrd6clsOLcfWQ+f7d8c2LCNAVHIo9gEdkBcbAS2Hj7Z4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 17, 2026 at 10:35 AM EST, Pratyush Yadav wrote:
> On Tue, Nov 17 2026, Pratyush Yadav wrote:
>
>> On Mon, Nov 16 2026, Pasha Tatashin wrote:
> [...]
>>> Instead of caller-chosen depth, the tree should grow (and shrink?)
>>> dynamically bottom-up based on the widest key.
>>>
>>> Plus, with bit 0 tagging leaf values, 2M entries can be stored directly=
=20
>>> at L1 and 1G at L2 (on 4K pages). Even for huge memfds, the pgoff space=
=20
>>> is much smaller than 64 bits, so in practice the tree stays tiny in=20
>>> depth.
>>
>> I think it is a good idea to allow dynamic depth in the ABI, but I am
>> not sure if we should deal with the automatic resizing just yet. How
>> about we start with making callers specify the depth (max index/pgoff)
>> up-front for now? The ABI stays the same, so we can add support for
>> dynamic resizing later if needed.
>>
>> The reason for this is to keep things simpler to begin with. That said,
>> I don't have a _strong_ opinion about this, so if you insist, I can add
>> dynamic resizing from the get go.
>
> I take this back. I went and looked at how xarray does it, and it is
> pretty elegant. I thought some sort of rebalancing would be needed, but
> all that is needed is to add a level above the root tree, and demote it
> to a subtree. Similarly, for pruning, the subtree at index 0 can be
> promoted if all other slots of the root are free.
>
> So I'll add dynamic sizing and reparenting logic in v2.

I agree; let's implement this properly from the start. Growing from the=20
bottom up is the right approach. I am not sure whether support for=20
shrinking is needed, so that can be added later.

--=20
Pasha


