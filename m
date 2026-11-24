Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C61C606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=orG14YQW
Received: by kanga.kvack.org (Postfix)
	id 3C29B6B07BB; Tue, 24 Nov 2026 11:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398A76B07BD; Tue, 24 Nov 2026 11:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF326B07BE; Tue, 24 Nov 2026 11:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02BED6B07BB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:36:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AE6DA844E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:36:27 +0000 (UTC)
X-FDA: 85470565614.03.1C32F9F
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3F55A0010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:36:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=orG14YQW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795538185;
	b=HgcyGcauMKJ75tllxNM4QjC/KfQH2EFwR8ZJteBjjmY8JMAESNrOdgU3KNuW+JCx79+3SY
	O3NlLYwPHOwMnZZUGITVRSIftpUfhKMN842Rj7QXhIhIfOWm7qT7ZHhnZ98UTmTpy/BmlW
	c4NJRBRm+aomHJ/p2gbpgFSyBdCUK0c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795538185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qvYwNBiIdSxY1ryMKCuJ8Xp5CwhF8vXQvRGoOqfiz+Q=;
	b=V0IKN/Qexc5PKMVFUYt3CR+aXuTN934LKO2G5rRiiTIeWi9v10URAs7qCCsazVV3Y2Ox/7
	5LLC04ocQYWnFQ9XOfvPa7xk4Ft3aj9Qjz2smHPKlmyOo18lW92lEsZDxyZbwAbpcxfDhg
	BYuGaA1GHQaw9hT+KFWnpQzSX6Xg+2k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=orG14YQW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso2404720a12.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795538184; x=1796142984; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qvYwNBiIdSxY1ryMKCuJ8Xp5CwhF8vXQvRGoOqfiz+Q=;
        b=orG14YQWQUIF06MAfjzCtSuVk2q3qghvlMzyeGJq6jyErIftkEF5xs/bcJ3FQ+LLkI
         vNO7r6V2Wymaxo+YDVWCQmTQRziFKXLTucZARwD/irm8CvuSUztqG5uMEnnnr5coff58
         9+3Rr3lqdNhzo6S0qRhvlQTAiSFNWGA8U6KHJD6+cXPy01+93ZbrjKXAkZFtKLMICEOW
         LLBkdfOb2OBroR7NVqH6Q3oUZcHFbESbw+BXPhps32GZIZlKEsLYcLRlzMFueRinMlF/
         dhTN1Dcasp3tLUNIl5CKuzpi2oZT71Ui0c5kqfDHjFJ/d8YxsoXInLYu1FUyt8UCL3de
         GbGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795538184; x=1796142984;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qvYwNBiIdSxY1ryMKCuJ8Xp5CwhF8vXQvRGoOqfiz+Q=;
        b=qOdJYG9y0ZnM9UGCvMh3xObNbuodmO7RWPhvcntgWyuk/WDlfxicI+SrgSw11TnQwC
         HMP4iPublbcUaYAMLIcP3WVXKGeioU1AOF6y5xRhCj6lqepaWvAehjfis8BCyblpnK2e
         sovcykW2cgiAj3NPQ6F7f5yAwLkXhfinqwYMtNESYHCVKWgUP+QO/iZH3Xt5rC6UQuYx
         krcjkEqsBIIs+r6lDmllM7aB2Xmb6NAAHQCqgHSatxI8tSabLdV0y2+EXMrWkxWSmJqG
         R1R0zHxiXmszwZnPgFKEjz93TZmZcfz+ChYcnfFlUtFg2jGl/7CF0Mr/mNOUhPQdf6Zh
         Xn0g==
X-Forwarded-Encrypted: i=1; AL+hErGxRmmJYwI+Gtg6K+SCzSUXKLEeZqk7vfqzj2hgDrFnMGkwk+YnQ/mtPmZuoWS3pxzQMDVXYxBJiQ==@kvack.org
X-Gm-Message-State: APuU4Z/ZF92Jw6ZxKNR9cPzFxu9s724KTElM/Fl1Fdf5owgo9AtPNp50
	/QXQGm0UrtD7rul8h8A/XoIKNCiEGM3hF7U0h62+QZfCMW4Rvs2IuqjSUVJ6m588wQ==
X-Gm-Gg: AZFdTZfh7lkJbycoGqE1zi+rv7DYtXw9Ay0mLDo4DrVjClEVCBEgFOylaIZI92tHAF3
	rtGxoykH/mc9Mu3YBHBfy++o3WA+2WBItNa6AsV4ZSYn7TVgdDiG32YHwidy81Z84gTEc5FMJbO
	8v3ylEQkz+08iOuOaGn4iy5c69ZztBWATyKZ9NTl8eAEvgfBASQyuw2n3j48izE2xI2xDAj1r8d
	rnhU+fN0dKKk03unvZrGd14DTCqVm6aYHxJ5wTdHp+EpARqJzzlm5+YLIVwsvIZlp/vO5JvPgnp
	Lc8LC1y+bXx2vR/yAKSaxFXOdGTrLrOn5LZQt+AugyWMlfB6pD/47LPcnKKBkV7ei+4qq+dXCdt
	QnVBReYDPK95ggtz4GpTorkFxmJgbPnc0VuaIHnQ9Z8AGxCvoNeDBvRincwtaQqOw7ZWvNiQGqt
	HA1cVmXT76MTh4rWWPqHMFetBwTFNsAXV8Rb+lPE43darwxh6qbdT7VO++CoVSsryLfohDshmDT
	75uaMBteMxD1HHWcMuqbsz1OZXe1QAqAKJeNaNedWIss5UMJOqTWbKCDCCvjj1WK4Y3D39+rM6A
	qAVxfjU5+HCeKF6F11llXRGwARJBoe6oLzSmfOTCUHVuKfCm+HTxRDL+Xl6QNg7r
X-Received: by 2002:a17:902:eccf:b0:2e9:64b9:a333 with SMTP id d9443c01a7336-2f03f17c766mr149220465ad.19.1795538183777;
        Tue, 24 Nov 2026 08:36:23 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f120830sm71740805ad.61.2026.11.24.08.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 08:36:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 08:36:22 -0800
Message-Id: <DN3L5XQDSVO9.1NJFYQJTS16ID@google.com>
From: "David Matlack" <dmatlack@google.com>
To: "Mike Rapoport" <rppt@kernel.org>, "David Matlack" <dmatlack@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>, "Adithya Jayachandran"
 <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Alex
 Williamson" <alex@shazbot.org>, "Alex Williamson"
 <alex.williamson@nvidia.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Chris
 Down" <chris@chrisdown.name>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Parav Pandit" <parav@nvidia.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Pranjal Shrivastava" <praan@google.com>,
 "Pratyush Yadav" <pratyush@kernel.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vipin Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi
 Liu" <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 00/13] PCI: liveupdate: PCI core support for Live
 Update
X-Mailer: aerc 0.21.0
References: <20261118223704.3286085-1-dmatlack@google.com>
 <DN0FL1752MH5.1FSZE620OJBM0@google.com> <awKlfqlQYhphXCvf@kernel.org>
 <DN2TQRX57C04.ZT5UUS6AQ1L6@google.com> <awVjqLFrXY_PCm7X@kernel.org>
In-Reply-To: <awVjqLFrXY_PCm7X@kernel.org>
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dc8pyy1gjz69ynpqjs6artxf643t3gi9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3F55A0010
X-Rspam-User:
X-HE-Tag: 1795538185-202221
X-HE-Meta: U2FsdGVkX1+CM430EyHYK4qgrcpV27CjhXxaXNKnpgaD6OXdXknxXMsGLS4SRsrDAvTI+LnUUdWx+FtQ7PXrpOPiNXnp5YiHp4HIeprWGG2l7XWWQneIWoyfsQphKgQLgwLGjHKl7KFF7Hr8OzukIM762XO9w7rEBsi43232FQikRKFBneOjHfAA/ubAaOtGyVcbMCDpbJ4FybdIn2fr/voRTcKsdfTpAK/MErtriTFyvPVOlMlKuUEOyc1cF/qkoh00b2C6kBtBadO1/2L7ITkn5O8DCU7KIqVdWpV4YpH9Gs+eMsJzbD92/6gygZJPx1gciCVMw2/UOaBtlOxPa8gIrolirc1ceGu1MfTQmsQ7QjkZTtd+5osSriewgAeOhYkOYJVe/5gpfwqASBR9mlDU1GQN7HC0Bc6wF1KlrBFZ35SWnPYtUs+aKXVqCWfftf4kVaZ5CIKzzy3MDGS/5E5UIXbVPlppo0R2m7BsxvyZlZmUPsquXs5Ekre4HGZE8UKNsM9BPhsMSqqCz8gMr7Ka3FP03qhb1g2ak67FT5YgEJHjLupKUDe+/5ogzy7IkQPBBdq9tbMSH0XHedDm3RsfiNMoRBNtCA4Z2QXob/RalkU7VWo/I+U5TIj+M241JaLJc7Oy6t+n7jcTtyRtVg1TpkiROp9dBnAaiNlaiBiTM0jfSsT9DezPQWDD9P7Q7J6xlf6cegCI3BqNS432/thGK2GNhVEKkSXh4jegrefOIjMrNDh772RUtsxjOSUKsO9OtDjmEVi+P3Wedq3+0Wo1LBjPeBbiY0VCPvt2xshmuQqX0ElKmeIYKO2g/d9QgKp4Oa/pWZ05Mc6SO+vu+caNASv68AFDQJRPbcB5z3voUSP92zA9EwaXs8mF9F2oY/KFiiyX+BjCA6MLvmwOsd/+KnZ1Y15/TlKPUf91GOIuFuki7r7kOcmnVeszoXlmGSkYtKHibf53zgusxfw
 MYeizSIZ
 mQ/oWMqNo64iU+njI72fkks3Tht3q6PCyuN+IUJ2BK8XNJ9Gl0XB6XZgybnohI0h4YEdS21p6S8XSz85zyl67iBktIOK9eWRn3IVViELNUGscZeXMxNvAGjMaGMWbljOrnzj7JIji7KrbrT0hmmq9YVlAPH/1oZ6lPeUGLyzhGClSoahDE/6SHaRla+XWl5TC63HX8P8RvsaVk1Jccrnvl86mqaCaSOuGT+bQIzNMlB3izE42neFmXHtsc+Gy3xzfi0Uf4fv7ALtk1TylH57y6BPhyWtbJ9VFNP7yEoS9qM8YIbE4B16dMNFATIIZukDcldWu+LmXZMVI665DVq6Yl2/8HL+VOvA91RXVf5Qq3/9LKY8oAQe4JYq47s6sCU5IaH92WeqLhJJhU9jGlajcAXCfXW9B6LrIUD0vEtXWdDyuL/MA3yXalSlY7OqJcDspi9POt8u9ZzZIIpJPncJ5C0nytjIzAjT/3KdVizLc/T0FRlALkCODRGKeZ7LkvFmQvVE9+zzLkW5Yl7aWPnkMqtJM5rmAK84ODp+815zuPNVAjZeClPvz6/3slDJOpcEKPAydvmEKnUyTzN7tKV1F7vh184tOF4UTJzusELmopTy0x9rMX4u9z9FNrxmJpWWwNSrlM65pHNqbA94NWo97J/PPRWQWPF/ejs9Gqq1Gkba2FGQRNuHJt5MHhu0YQTfAkzy24s2PRVaB3yW1eRJJA+BZBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 24, 2026 at 2:15 AM PST, Mike Rapoport wrote:
> On Mon, Nov 23, 2026 at 11:07:04AM -0800, David Matlack wrote:
>> On Sun Nov 22, 2026 at 12:19 AM PST, Mike Rapoport wrote:
>>=20
>> Hopefully I did this all correctly... This is my first time sending
>> in-reply-to fixup! patches.
>
> This is my first time merging !fixup patches and it seems b4 managed it
> well :)
>
> Please check I didn't miss anything:
>
> https://git.kernel.org/liveupdate/linux/l/lu-pci-preservation

Thanks Mike!

I checked the updated lu-pci-preservation branch and the code is
identical to the v12 I had prepared locally.

One commit message nit: "Freeze preservation status during shutdown"
ended up with two Link: trailers, the original v11 patch and the amend!
patch:

  Link: https://patch.msgid.link/20261118223704.3286085-12-dmatlack@google.=
com
  Link: https://patch.msgid.link/20261123190045.2166865-4-dmatlack@google.c=
om

whereas "Adopt ACS controls in incoming preserved devices" only has the
original Link: (not the amend! Link).

Not sure which is correct.

