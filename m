Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B7C1CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 02:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556448E0017; Wed, 12 Nov 2025 21:36:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506328E0003; Wed, 12 Nov 2025 21:36:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5478E0017; Wed, 12 Nov 2025 21:36:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28F128E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:36:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D09B913B965
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:36:08 +0000 (UTC)
X-FDA: 84104019216.01.8879A32
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD10040007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:36:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=MluhG3YG;
	spf=pass (imf11.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763001366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wU6W1sOwNniOpGHk04oKlDXcIE9zKrR6PDF1cQwJ0Ag=;
	b=bmBKSxgLRnUOHZPi2X1YV4mmpBvux31txuvunGf6adxigcyXowG5sqSZTjtyPHtnoLoei9
	K72up2XehjWUmVJ780yan+Kvuzvq/JACLfywuhL/YOXrJHCRgcxkMn6Fl7l1zRV8tmXND1
	grzQRrj/8SPuQ46HDw/Nga6NyRMy3bo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763001367; a=rsa-sha256;
	cv=none;
	b=0AZFqmkgHEPLLMlFr78OFuw3h0Z6ZlZkS7m5tat608r4IP7QMH5hAHcGOB8bvm2tdZUx8K
	CFJ8jEZAQh5lNVtrktbRhddymE/GwIP9MmfZocFCGLuRk9ZlR/9+DiS+kyF3+4l3hIGBkn
	8QSKCoGe7Li5TiAnTya69pY6KuIpNkc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=MluhG3YG;
	spf=pass (imf11.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-4331b4d5c6eso1641335ab.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1763001366; x=1763606166; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wU6W1sOwNniOpGHk04oKlDXcIE9zKrR6PDF1cQwJ0Ag=;
        b=MluhG3YG0MxOcHjNc4i8khO6cL/lbfqGMGrKrGzALEAvD33ZG9dngb5PUcvzqoRPhV
         LwHpkL78YIpVY12l895+BHWFe0p8AbjOTHFMLzpKorGqTneB9I04TpeEYLZHuhcOWhne
         lITZXcrRLwuU9QnQN2NfzfqSQPkQOrN+oNxsNC2RrTuIA7gQ9cb6jSxbPPJ/L3q/ah2b
         oZQTWUdlRE/pdACfL/30+I1ioMnIIi9W61MHR4T1JJqfuLuPyt2NN7Ssr8JaSQ8MBgXr
         CnuK5zECP9LG37D6cXllPbu+i3j6aLPYC9NdVEeUTN4zDRQ8PDXremecoW6H8E4/h4aD
         cpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763001366; x=1763606166;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wU6W1sOwNniOpGHk04oKlDXcIE9zKrR6PDF1cQwJ0Ag=;
        b=HswFdRW0w15+h0HYi+m5h070EyC/r8O43SwIUUOvOR0IgN/yntHvk11lxW4o1UpKQX
         IAFyrCPijFPboBNvVTBrre/NyC82dn2lczxCFl4rbaJVUNsempxFZ9+OaDdqJP5FK8rE
         vBPZMq+WiFJZ8joaXW4rRd1RiLbouI8pwJObxWcN0Ije0LbXXicW3EBLmwKCizYu2ghj
         PfQhFe9jGXJYCcixkqCCM25qBMv2r3UXs+eOk7j0BBLD7H0L3vnGVVpqly8ktjBBWSC9
         fcbVYSaYdD3YrV/w0IXZ2xjqXWrqkTxqnua32UQ+WP5QYjWKW+2ZH6M5+rBPDQKqcmt2
         n70A==
X-Forwarded-Encrypted: i=1; AJvYcCVyasqzX5InrcDR/3fR7VMf8KJTKSTQnURCZKwgyQwCIKzjcIuZnZXX1IfVz5joNzZCkgEGFzrLtQ==@kvack.org
X-Gm-Message-State: AOJu0YxCZ3kkOo5SYj1tqDtA0VFTNdCo4/t0GSP3y3V6fWvJKgGF96VN
	UApxbTWCrlE1sgDKtmVUMajJ3Aa2Tb8Xii82LMIUjfJeX6/4dT5dS5/J+fjahgtoHmk=
X-Gm-Gg: ASbGnctCNRI/zlVslH4VBVPeksLytcTjb4BpooGfrX9FY+z4PuRSgVR5lIVesOozoLe
	TtpcB0unjNBLzM3go+8Rqc2g/hm1/TWRdU72R7hbB6dUm3gUWzxDkVuq73nsj3wGoBDTlzCI8dE
	JLbR/Th481S2bynJRYoi9fEairLjAib9iuXsC+NESJnaMY8rpCfbvdbHSM5jKh/flEODIdL74MO
	Zk4q4fsT7WckxYMkK+aHX99iiKVlXRHAXsbrM8MYBGuwbHgemap5QPjzgvfiSDgEwAEHKwqF+fR
	sJ5V0tUt0gzvAV4NoY2Sfx1lAorBFX9d7bzIvCQQjD5jSCzxOLy4T1IJ7f9M2y+HaT6wqvD5Fnv
	9eDFDz40WJqObK2uFYYTWKDJRgkjjvb9QMBKtyPfOgX48DEDUIXYStxi5mdiMJtqKwlK4bjxIh/
	IRUIW1qNiRG05zafVg
X-Google-Smtp-Source: AGHT+IGraeE/bIFHpoWCxTBowHF0q/OZirZ/vsZdNcApHxPGLPbWrFtEzHUR2rGHxEjy2kfVThP5Xg==
X-Received: by 2002:a92:ca0d:0:b0:433:330a:a572 with SMTP id e9e14a558f8ab-43473d52e46mr77508645ab.13.1763001365760;
        Wed, 12 Nov 2025 18:36:05 -0800 (PST)
Received: from [100.64.0.1] ([170.85.6.171])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd26ff20sm267252173.23.2025.11.12.18.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 18:36:05 -0800 (PST)
Message-ID: <a6e7a571-91d2-4e66-bc86-ba30f624294b@sifive.com>
Date: Wed, 12 Nov 2025 20:36:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/22] checkpatch: Warn on page table access without
 accessors
To: Joe Perches <joe@perches.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Andy Whitcroft <apw@canonical.com>,
 Dwaipayan Ray <dwaipayanray1@gmail.com>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-8-samuel.holland@sifive.com>
 <1dfa1e3566cafbe43a1d4753defef9c82ddb3b64.camel@perches.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <1dfa1e3566cafbe43a1d4753defef9c82ddb3b64.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: CD10040007
X-Stat-Signature: smow9x6my1u346kafspyszrobmiw1mq3
X-HE-Tag: 1763001366-118116
X-HE-Meta: U2FsdGVkX19alh3oGQoko4njg2t7xhFQ+hp1LvdA9j0G1AmlUn1PgJ8X6yD+R0rJbMmuqtLKofzwtHZcQ//zHfH7/uARw/Xig7szjCtpY4PWYbC53BJ/ikXGxZXnvHjkBGTZccF4NWZ80IJtWMwPjWzGkDy7ylHmEO3FTGrajPLX0N1CYB7WZKvu20MFnh8Pz7n6+nIT5nnvSaUhOljZcVckY460R2i2p+5P/tRcDo7dlV1d7R/7Lg1eO88qkE+ymAE/XAEeioNvvn/ub915z7DXCqgFYyum3wKwCs8l8CkuLtKx3aeTzP2GoaKzQdGIOeya8TfIQuYK07JvNsdh4zDekvOYahb1Cv0RbTpca2BgJ6Dbgq3wCvpymHj6KT0ClVoFT8XJs22uULiRCK9adjbDxxle16wJS0OA1Sjj+Syt3aEVBLzneMrkJNIAzqTFR+c9rQDwxGuCydp5iqt7jZSWzY1GrDvZhnZTMzUDVpQFVOWLbhdzhIyE8fBA47ZxGWU2jg3AiCxhGhbfQ4UmEi9aUa+j4te+uQr9+DkOqkN2LU50kw/q4tFW3G+0q+dDCM5MCuLZAy5e576fndQgczspwyA1xe+DMqR5Vcbs3mmLAM8vmwO5SkLLO42k9WNe59Uz7tqQrlX5cCQqHdMzx6REmF98r/ggHvccHoqvIGAE4DPj2PS0CvNwQ3SqXh5SzKq33E/ApT/wNl3NWgIOZ8FzsmzAefF9GJlSmxMhsg2RkaOeYBwGVbgbwyVSPWNwFzOoY4IJILxp70usCU16yTh8m1P0gn3rLzJO3cl4OX8PeRGEGfuC4N5sFn+EUDiNs/a6uY9cX1ye095auzgV1n04PuaxmE6S5FlNuThOdcIdve1ige1c0ozmYBzZewRuDEO3Ma2Zj6/BwkcV+KZbwjBARSvkPV6ZWzSuJQEroZVKrC3tDkkSlsIAXEW/zGymNwiDsJujbqtahhJIXpx
 9llgG+z7
 fHkjvCpkcEjpx8s15JgX343G+AEHLYCy57AuS/LhXDAVDfIY4881NIULF1L8L5YxhgUDARSbtM1F+25iP77UyR2TfVEU8W2b92DjsVyPp7Ggs8OHWmyZ8FFv6fcW5GfGRPB4jn1YOXYK0hG/+ANGdYSLPsNNoloLcqunLn3QalFKxpkrW3M8zwtygRqzJwm2kTVYdy6wqKoD/sMBMiuFePj9Q0cetAIIYpMfjewpAUP9msTMOXRMqLDsGmS6ACiA2YzLFUKkI2rbgNCaBFH2UUC7n1l4QD4sQre47rEymt3aG/JBOvtpBhkwDsUOavT+euOKRf9YxK0LJeMZtEpArGlBwwvi/ahoo4Sqk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-12 8:21 PM, Joe Perches wrote:
> On Wed, 2025-11-12 at 17:45 -0800, Samuel Holland wrote:
>> Architectures may have special rules for accessing the hardware page
>> tables (for example, atomicity/ordering requirements), so the generic MM
>> code provides the pXXp_get() and set_pXX() hooks for architectures to
>> implement. These accessor functions are often omitted where a raw
>> pointer dereference is believed to be safe (i.e. race-free). However,
>> RISC-V needs to use these hooks to rewrite the page table values at
>> read/write time on some platforms. A raw pointer dereference will no
>> longer produce the correct value on those platforms, so the generic code
>> must always use the accessor functions.
> []
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>> @@ -7721,6 +7721,13 @@ sub process {
>>  				ERROR("MISSING_SENTINEL", "missing sentinel in ID array\n" . "$here\n$stat\n");
>>  			}
>>  		}
>> +
>> +# check for raw dereferences of hardware page table pointers
>> +		if ($realfile !~ m@^arch/@ &&
>> +		    $line =~ /(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?(pte|p[mu4g]d)p?\b/) {
>> +			WARN("PAGE_TABLE_ACCESSORS",
>> +			     "Use $3p_get()/set_$3() instead of dereferencing page table pointers\n" . $herecurr);
>> +		}
>>  	}
> 
> Seems like a lot of matches
> 
> $ git grep -P '(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?(pte|p[mu4g]d)p?\b' | \
>   grep -v '^arch/' | wc -l
> 766
> 
> Is this really appropriate?

Other patches in this series remove 277 of these matches. But it looks like a
couple of driver systems (iommu, dm) use variables that match this pattern as
well. Limiting the check to include/ and mm/ avoids the false positives.

> trivia:
> 
> izeof is really odd looking.  I'd prefer sizeof.

I agree, but my perl complains "Variable length lookbehind not implemented in
regex m/(?<!pte_t |p[mu4g]d_t |sizeof\()\*\(?(vmf(\.|->))?(pte|p[mu4g]d)p?\b/ at
scripts/checkpatch.pl line 7727." I could split this into two patterns, which
would also solve the false positives with multiple variable declarations.

Regards,
Samuel


