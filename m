Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED68CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 09:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CEA58E0003; Sun, 21 Sep 2025 05:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D838E0001; Sun, 21 Sep 2025 05:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5934D8E0003; Sun, 21 Sep 2025 05:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36BA58E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:28:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A8C41402B5
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 09:28:09 +0000 (UTC)
X-FDA: 83912731098.04.448CE20
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB75B100005
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 09:28:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UAIygT7W;
	spf=pass (imf05.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758446887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtvX6spi3ViWv5XUhchmyhouze8VNd54v4OZj5G0rRs=;
	b=HKvjmJ+LgqnZs85RGlFPnTL2DNjWItrjYPkeN8LWE4wzIGUnzy4Ieyw6SER3R67s5+Yizo
	pwkt6qm0WRkVbWfKyI8CoDbKDiGlE3Erw0YNH+ehX/2S2AB67iIkOamlmYkZRsVH3dAUx+
	HRv/o07Fk7gn2OVVBxz8A96eThwGGrE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UAIygT7W;
	spf=pass (imf05.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758446887; a=rsa-sha256;
	cv=none;
	b=clSLg+BTW59fg3Vt7xKUyBnbfyvLIrOXQPB24dAfz993y+MQCMLiFsArS3pgvE3Uci1fpV
	KLx7JaDibk99gw9E57FJkCLOXWCEAcih8QbXWMGYcJzo4LH0KJYgUP7LpllnINT1R1+pn3
	+Bja5LxOAbmDR7tQkCIgGZ4swqbARrc=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-267fa729a63so6468225ad.3
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 02:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758446886; x=1759051686; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtvX6spi3ViWv5XUhchmyhouze8VNd54v4OZj5G0rRs=;
        b=UAIygT7WabmaVUz7SP+p1Zdxk/a4MIQIxtmq4Lba7Vn8FiK3YAQEYEmP1M5RsV+mq2
         NIhv3NGkakMD48TxHFHzx0bDrYxowou64jYajFJ8+dA8ErnAW1Qv/avf6ahHUyhNseN+
         gDR+j8VVS2nLGeml2fLLMTb0ZXZTB08VECoT2ktn/TuyEGyApZCuDIBwVXmMvrY1GNQm
         JyTSdteD4KNGcXSfgIIfXxlxJp6FY9IOgZji2KgVKOZ+JWX3CB+MowLoWhGGxsEkBtAd
         1PgXhT7e8aQzLfeRpQ9u7L9WrweE8SLZmAgUUIwN3A5fSRxQenshWAY2ANtgmvH1iiKp
         DXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758446886; x=1759051686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtvX6spi3ViWv5XUhchmyhouze8VNd54v4OZj5G0rRs=;
        b=YkrgmgiUf8303Xn2r9AA4M6p0pF5reMpIGQuHXIiDARXhjIdIx1dau92skWGZQcPYd
         s5aUAPyim9XvrM3jfPGoyOSK1a6y5fYCND1Sd/GAxso7gP3JBcKiDwbxRsNkPcTE9gIE
         hFRAX3DdiVE9bI1ErYygwYlADxlVD6nGEhrlLvXTeRv2jEEPAOLBDn7cv2TPt2mEXt/i
         k5tjfjXZCF1IzC/I7IhQLvFKkgq9Ku4fuXRjVYzmb3COVUEbMiNC2VMrCfZ+/ZbAO1FH
         6TrA75O/K++u2nIqXa9Lk42gPAvmN2OJ7n0Z1iECCJ9xqWjQknM6AftryZwJCmFqaoQt
         fC8A==
X-Forwarded-Encrypted: i=1; AJvYcCUtnmFKO+4xs/rUTG3vZkjnxImHc2pOzQNw/JoLgLVT+5eoqFqdxj1uL/qmtqj7RFCK+2YXKWdMVA==@kvack.org
X-Gm-Message-State: AOJu0YzHeaz2k7SvVh4VdyVSdAcos2RJdyLFyfZOFIGDvCX9v4ZT/MuI
	I+/nHKritLjuUjpH/OML37wVhAc7N4tasQGTamOQy+KDgRu48g7Tyu/tEO1SnJ1oGJnfnI8iu+U
	v+6AcKpE4obnqbEUxXLW37IHspdBHqQg=
X-Gm-Gg: ASbGncs+C8p2JO+LaAp5Y04R6lTiTUdSLPNL7Q4w4tRlpzoIR19rGIzvOkss9txbuZf
	S7jH2m95IPkNpdqfaRBg5LZdXz5Miw0yaMc6S7eUao7e5HWke0i+roBfgcg/D8JLIHb8NygKZek
	kLRVahlVl9Ow1ABlmC7AUKJ8X9Z/ZmhASX+IBTNqrO3B8mCJW2LddEMvqpdfO6r3DVyNlCtafka
	vS/bUu8a/kStHMPorgUjD6wEF3R1hr5tC2zFLYGSegBqP4fbiF9IufOvN7iQAw+RXc8boHsBcb5
	xyJrf6cvyzob14O22p9XztjR5w==
X-Google-Smtp-Source: AGHT+IF+Dy0mlMIwczvjkrGSGBlKSHADOTMAlhPepZLysPmcUI5cC7xm/X9KEYN0oiR+8lSYpv07g4tim48igZ6n/UI=
X-Received: by 2002:a17:903:60f:b0:269:af66:5e70 with SMTP id
 d9443c01a7336-269ba53ab71mr45154625ad.9.1758446886509; Sun, 21 Sep 2025
 02:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250910140212.997771-1-ojeda@kernel.org>
In-Reply-To: <20250910140212.997771-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 21 Sep 2025 11:27:52 +0200
X-Gm-Features: AS18NWAoOU3I-I-O4oc7FCAYxbAppgw72ctHtbKu_NpY6kqn7EZ9tMfGQmUs_fs
Message-ID: <CANiq72kB5hCC9A9bXEx489E+SMMFcFMiJB68NHA7megz2aG5HA@mail.gmail.com>
Subject: Re: [PATCH] rust: maple_tree: fix intra-doc link
To: Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB75B100005
X-Stat-Signature: og1matohsoja9ghbfg4fdk7giqw4rz6j
X-HE-Tag: 1758446887-588035
X-HE-Meta: U2FsdGVkX1+vsBllbi9chq6Gbl29JpINq97xBfNDHEBxHRNl28aNo4WGohuGKeQvGqIx4/bIv8eXBrpoC5gHnPmL7eJq9+VbhByDVJwATXIP+jSLKNwUDXeiILHk53AqiIf4RIBzw9/dyq755aqd+yk74fFW754dzVxUo4gc7sLuV75gkR3ugoo8q24ntNvUWlQZ97UujIFunskCZUo7XzX+ayvalDtUCOxrKkH9arUeBrwe4U0M8ppCczmNcebBwCzxQLRQXkHb5ZFlT+81RzlUpjYAUjB7urPm+7eaKaG3C+9YBErbgVJSikHz3giBdTnbz3rsdhMraPilbvgC6HMMcBiAp30O+RPPKjHHIGYKvWFdRheSf3lzQNuC4PJqLvxvFCXiqtvoKeYUGlWsJNFawPkWaenncU/uFlKHualn2ZQfrpfo73HHE5eR4P9o+s//8n2MNSb2WwtQhO/zO9pYxTfIEGapR9e/1N5ntQv8b306B8eTSf2rJroc+5/AslEh3n/5qpRJKuV8kEyeEIcqJo7FOHAGioUMVeO+A3/a0woFguUkSIeE7tY4ugZVT4rsRKafRdHoVXZB2B7Gm/IhPvXWAdjPz7GwvxhO/tHyIFAjNgfCgTcrnsmzUpzktGfryJ+BYZE0BNAAme6X7J88OHv93cmVvdPLwIghyzm/UKBaW3KsJjCrAB+Ve+MFAHGK6AatYGBQvOQoGnzWab6L72MN0bISK3hyA0Ek1FuoJl3hLEKU7i6wv7CpZlm3oDWu4aJzUQ5PV/q+DhwD7QB3clfWjAmn/bMj8ygzNybUqdFEbYayu3tb97XMfWvCnpfcfn5yYFhOVSIGycSF4DzxBM8Oh5tW91JEGUtdJfV73dAe3nWjJ6yMovzHc0phzSR6IQi4TVNVgigW6zJBSa8KbFoR/nbpokUdiU+KGEvQZykolcg21SwzDO1AqrrIakb0O1xAs4ibB89uhJJ
 ouTzMIVs
 Xn+t0qpHRACw+T3jQdhH/Bnea0Z+issICWUmt0Xj2cEkH58q3UGkF2Xl5aSOIhkfkuJz5NqmvV4amoo/48pRraATFpvamAOn2lhiI5fLHZOumPj5Wt3fz7G8UzOQ82zjyctsMDFinF9lE8jIuaTI2hsE1KTRnVTIEfPDiEhQZQB+5+d8qo672tuefEwsFV7mdx/7KoN7QoeYQI+Gsy7sHACuG3nC951P0Cv2oJ3wdqcSnGchWEco++eS4voJ0zBqP60G9qbBfa8LGshgj/rfVqxrAArnARKUd/+m/Qj/jHTlH7xOlA0Uza6I4GzT2igEH4zO9uivw0LjVUi7xkQ5Z6l33QUPi+PI1zErkERAvzjCgCESkUQHoawzImk8LtZjVQY1ON7LN7Ii5QRTUn4RYSYkHxHkqblmmfqquuUQH/mmww5N45mBuEC8kGng1tcHphwZKGJ25iQbW3dRlFlHlx3JvnODRdvaebqdnPKplF9T7GwSPfYTE+V2lGEvJty4dpoJX93VpvNyPnCNy5jkEosU4sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 4:02=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Andrew: as usual, please feel free to rebase if that is what you
> normally do, of course. This was in next-20250910. Thanks!

(Somehow I didn't Cc akpm -- doing it now.)

Could this be picked up? It blocks generation of docs for linux-next. Thank=
s!

By the way, there was a rebase -- the tag should now be:

Fixes: 6a25c101c7a2 ("rust: maple_tree: add MapleTree")

Cheers,
Miguel

