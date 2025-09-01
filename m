Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5BECA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83648E001F; Mon,  1 Sep 2025 04:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CCA8E001E; Mon,  1 Sep 2025 04:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5CB8E001F; Mon,  1 Sep 2025 04:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD838E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:34:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17BA51A0732
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:37 +0000 (UTC)
X-FDA: 83840020194.26.476BA0F
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 18B5840004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FV5kJ3rE;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbrHRTPmVoKlWV8ebWI6m112D0ytwDz7+ZvqI/2/bKM=;
	b=waLo5sIh6FBNTKJsMiEpGjFRq//9iwDdvsxIF8KtwpxAiV2SdnuaOC98VDUtMOXsK9EYLy
	mfHvTS+kvjDzYFE65XkEs4kwLPa2U37u3NMsbLestQZJ1RoX2iOyD56SyzCjZsW2UfkRjm
	Lh83MqDgvB/a8Fujvgy/TN8jjn3HiiI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FV5kJ3rE;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715675; a=rsa-sha256;
	cv=none;
	b=iYKKSzz7CrX6pyOolvgOc++h4pm9qMVgeW+3sPiIqkvKQsbhE81PEuD8KepMrI6av7gkPA
	J6mMT7BpkP9dt/CcGFOX7LET6vyujO57yRW0984uOZUWVHG0YGgiFMVjG0GiH25HLq2UUQ
	D783nM4ou2//ZKQ90hZZooMVutraQmQ=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2487a60d649so50491485ad.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756715674; x=1757320474; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbrHRTPmVoKlWV8ebWI6m112D0ytwDz7+ZvqI/2/bKM=;
        b=FV5kJ3rEsRZoir9djRioW/lOV995FbgqjHrAoRsMzUI3lnFN3GrRiHtQqA+d2w9Ao6
         SnVJRsr5UVseMePxOQWJludj4rEfJcN7DYp4uw6yInSitOiIcXeQkZjA1liOU3UuviwD
         rERGGlRIiRMS9Mywwnnwa0DVlUdU/GW+r2sspwA4E7/hR0Xg3rFjXFqEVwDqJYU2zpb0
         4CuahEP3gI81nGuQXbsUq4NBuiyyMfTic8ambtdl6eMB5k2b4J4MinCu5QuSYBP9pDfP
         fIPjVbnBJ3v+nD6zd7q3Hu24mTfpZXkWHlK/3p8Hm+gR/ZFa/w0SgFW47YAyuM6Qil+f
         tfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756715674; x=1757320474;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbrHRTPmVoKlWV8ebWI6m112D0ytwDz7+ZvqI/2/bKM=;
        b=PxNdv4GBh73zKNo1zQ+KMbvmEPPkvH0jQ05J9paUk1WfaDtWguTmAe53JbmQTLjONG
         PhDAmy65gxha+xNjKxk4/1mWO9WU63pdoS1JL4Yu6sjf/2wZrhCD/C0qw4ljiu4ezo+9
         0K8/3eoz2ReBHWMamP5s1T8j7ciRjL12uym3NU5fDE6dkZP52ODHet4p5/uzBw7q6zaf
         kg1Ijui5YH+xjhCkoDvUddu7gmrL3fXL35CvaArUgv58cMPkbIjYlCsUDEtGKjhC3vmo
         DjRm4EdDLxlOHSgAqWXhYWgr3rTRAx/PNPfI3vFFAbH/gbxSpE7jwg9GbjIzVBnOCziO
         ec7A==
X-Forwarded-Encrypted: i=1; AJvYcCXWo+qhdP2/rf6ELnPVbN4trZTWRDivkpPSj2mXnFwOzkz1SjIp291N5qU/4J+lqBDtu13gjkiMbg==@kvack.org
X-Gm-Message-State: AOJu0Yw89/vI54oQNhocJoHIn4Ihgf/gojSarq7yd4bJ42r9JQC9wiqm
	B3dCI14Q0bucHFuywTeI/J9hFNhX0uxQFrUPW3eoGbH5kkB83Ygggqev
X-Gm-Gg: ASbGnctrHpnrX4bWsYQy3p3WG7q9lY6ZS/fzdEDKPF9sDAhP+i47U4KaPPZZGBMxfJB
	EwpMNIcr+9ePcwm8Fda3YYQgBH2WnbA8E2fZtV3CVU09w4cU++NwKaL8OyvQJXYVMZs2s6J7ktC
	yFOR0Tj+cYx1fCt19u5qDOuuetZZCo2fmK8b8c/2mHDxt4AUcNoKEDRNKPTcWqn9Ckj6VW+mszd
	m2tEW5feARhoyTvtUMw5/X8oXhgpr3YarPv5PN1Xt1K5GNbgTky50cWleo0ytgauTHRz8uOGOr5
	1ImDDljraXWlHhSliFr2r62vcrOXwC8S89TrGL/iybGhUdpIDpPUx7O6EeDrX6irdXuRWg7MoJG
	WTc/rN6AJbQ==
X-Google-Smtp-Source: AGHT+IEZfowSjilBRafTP9QexzPy8Z2u9xh/wUFr+pZVwMnJoB0ioWxzEc4yKBd0BShD54d8i51GmA==
X-Received: by 2002:a17:903:1211:b0:246:464d:118a with SMTP id d9443c01a7336-24944ae8610mr105522365ad.46.1756715673865;
        Mon, 01 Sep 2025 01:34:33 -0700 (PDT)
Received: from smtpclient.apple ([2400:d320:2231:7720::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903724c62sm95960595ad.34.2025.09.01.01.34.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:34:33 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
From: wang lian <lianux.mm@gmail.com>
In-Reply-To: <df27d5cc-bac8-47ee-a03d-eb1eff6dbe39@redhat.com>
Date: Mon, 1 Sep 2025 16:34:14 +0800
Cc: akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com,
 linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com,
 richard.weiyang@gmail.com,
 ziy@nvidia.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <604B12DD-4BF7-481D-8E09-0D97C8843639@gmail.com>
References: <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <20250901081109.52460-1-lianux.mm@gmail.com>
 <df27d5cc-bac8-47ee-a03d-eb1eff6dbe39@redhat.com>
To: David Hildenbrand <david@redhat.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-Rspamd-Queue-Id: 18B5840004
X-Rspam-User: 
X-Stat-Signature: dz9tdu7r7kskqzf6r9n7ucbzqn3uazgh
X-Rspamd-Server: rspam09
X-HE-Tag: 1756715674-980014
X-HE-Meta: U2FsdGVkX19r4urnoG6gISt4jq38tN0VzqJlC/2bVTuBjYLIYJTO1/PgorcXWsL/0/+FnlsItzM4+CmirrgzmoUsh+sX5UGtCl6vkhT64CzMHs2a7xGMgl9fEHvzNphfvy8m8aoDbKD4zVET4m3+z2iGLEQ5qlPTz/DpNnEhbDQp5gJ+zGk/LUJlZ+7U3zjP+2Iy29OsfHgGJvG8wTvsz+KLmIA+6BLKNooTazmlfN4Cj3nA409T6zjanL3nwRMMNqP/RcsNQyyfduTVcVoRq9IbCQO/cLp+qyaX1tW1aSb/srrwrsLn+m7DhAQv5Rh6H5MY/OhLo/5ZsS9OtB3BKXoGb03kz46Gc6fAZghwkspcW8sA4H3RLHhTnR54IuGUx/D+nN5sqQCwpqnmm/qRMOh88GBkEku4OYzPti1VZNLfLjN/cYtg+DyGyI8uh5Yv5nHka1+WGAem5jNPmxxwPARZQKtVO+A6JI4CiSQMzj9r1+sse7Czwk9bnEu6IBbTPSDbXr4CrwmN43KtBw1/QxN7Z3qQC9w7TxXLNlj8Fe0eGuPcQr74LMm9RueMhqP19neU+mwav8TJy2IjXkWWdSNzM2elTqe4LANlJfdkhKDZdvAfbi6h3LkilI2LAqcoLC6YZJyTajiCZWI5hClW2jSt4rHijvTW0q75uOl5fL103LtvAjrCeZ8/b3GDsLZlI+juOkzC2BhTVUy0Nkz+/m4i32rnwCoMkfgghgee/0UP0pwXIzSaMzpohp37o2eEepN35ni3pGoHsnlzrinLh7rH1X1FxECrkS497YGE6T4ZKhzxK7S5O5moT7bGhko86EGp18a0LWsdFcTXbKv30yUQUM9Qs01l5hsjFbBZ6yqe0Ey2yU7aU+C7wQFGgtX5jyxJ0igXLi4xtQpPGXmkNhZYfJNXnVhgW4o7OVBNIuTu0ssxbZX+t/mviCgxBDLe/Vcw1sEjptNEDBq959/
 Qs3Qlst4
 mNY+Tm2uijTPf+r/4dKDuetTcu7jZW7aeOz0bqwGc3RDBN3T5wp9jSZTtC4AhYvr19bEuEUC3yDqfpj44Pk8JBPd4B8odD+GGh4YAj0A+FFdp92JLeRuqMfRdcIjjXhQKghCNCqsDKIzqDz9j4/XQQ1MPCxwns82m23oXzaUEwRpxOMVAD0xkF1GgcPmndmy8BhR4Xjbuc2N2IQPC86KvUtYiyBRjGMveG+j70QnrlTeZuV+RabB41tYO/wTjWDwkLzeMOfYZBwQjO5eR21tPtf2p1cRTd59pLd1AQhlYBBOQf6tmySKRwtTC853Vf4jyVTiyY1kr9qHNbxHTbZ8MfVWns8lZWK8QpymyTO19q2x+AjJ3HphjjIZEPppnzPWcdUMkQegsnaj0e3oeyZlR3hhN9EX4dOOLFi+0qEj1cvP8iz3WbL9N5KxIAknF5oFL3bdmQvP6whuB1+VYMYMUU32nb/yOx4ttzHLCj/L+aqvkkjE+2um1RcKe8wOB0dtKKEa3WTSfFa1WSy9T2VAllntlg68lKW6BjG7Gha1r3hJWIBMVXRjTWjaBnMBITdi6beuP1S+1hers3hbNui0x7tIhjoEdQUk4+OWpw/pAN+TYby5qft+w/oV9Rkd8zgccfVRU3NwAKzUEo/e+4mfDlcbeww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 1, 2025, at 16:16, David Hildenbrand <david@redhat.com> wrote:
>=20
> On 01.09.25 10:11, wang lian wrote:
>>> I'm confused, don't we have that exact check later in the function?
>>> Your v1 might have been better, unless I am missing something.
>> Hi David,
>> Perhaps you missed this in the v1 feedback:
>> =
https://lore.kernel.org/linux-mm/E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvid=
ia.com/ ?
>=20
> We have:
>=20
> 	/* smap does not show THPs after mremap, use kpageflags instead =
*/
> 	thp_size =3D 0;
> 	for (i =3D 0; i < pagesize * 4; i++) {
> 		if (pte_mapped[i] !=3D (char)i)
> 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>=20
> 		if (i % pagesize =3D=3D 0 &&
> 		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, =
kpageflags_fd))
> 			thp_size++;
> 	}
>=20
> Sure, it's after the split, but if mremap would have corrupted the =
pages, surely
> it would still be corrupt after the mremap+split.

Yes, so I think it is correct to add this check in mremap.
The check after splitting already exists
>=20
> --=20
> Cheers
>=20
> David / dhildenb
>=20

Best regards,
wang lian


