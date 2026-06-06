Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A7FCCD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 10:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7236B0005; Sat,  6 Jun 2026 06:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79D306B008A; Sat,  6 Jun 2026 06:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ADDD6B008C; Sat,  6 Jun 2026 06:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5306B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:20:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E83FB1A03EA
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 10:20:32 +0000 (UTC)
X-FDA: 84849093504.30.8B51E06
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0193F100003
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 10:20:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PfTWmhLv;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780741231;
	b=peljMo0vixO9Tb0dkqoUKvMDkOoZUZpIFVrP6kmRGdhSOxXbkWYVLWhYFX9YTCQfJJKr+c
	IR1EGVcjSoAnubSdqnuwDeUgmaR6l9+idaAhems/IiVp2WTqEwhxWya3HsWnr/lYaDaJEi
	mrwr7Pm0PYb1JyCDIaovjlFRShEDtV0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PfTWmhLv;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780741231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rI4D0m/tct5A6mLgdnGzeGFfOZi2MuVNzAsWtboD2FA=;
	b=IzxaUIBDGObpRGQs4yy3dCtu70QQ1mBcSOdJ1h8Yyo5c81ehX2EHhpQWO5dGKv2x3etn6k
	nkYpXAqHJAs72GAude/ULnFiib8IN4wawWKnRJf3BFPox/nz6B+g8CL8As7Lmoo/O1wpRB
	x8m46tlG5NMAYv/PPWSm9/l7gR4GLEo=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-137ff9a7d5eso16847c88.1
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 03:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780741230; x=1781346030; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rI4D0m/tct5A6mLgdnGzeGFfOZi2MuVNzAsWtboD2FA=;
        b=PfTWmhLvjyMG/iixvswEK5H6C0hnp08jbFiiDNd9hDPU8HrOF9g2V1NzaJZSGe9X4F
         ECZCNNYo1lZ9/W5b0cPy+UmxUB6Hsk1F1Vlva3HRFitq5B4z5SS4ePtMoibcNFnV4m//
         U9SiAgXYHOHi7/GHzIYb5aCSTq+TaWgyabNGINSc9JZOcY4wHvyWi12nM/7qG+Qr3qmF
         p8OCBGyPZwK4iDAOvfzq3JrRzgULwXafdWdpaYmNNah/70Av3JO+nml4rBqgMe2nh0cK
         HTJE1r+o1x6oZj3qzdEvAuXbmgL7xOpgiuUJh3vylhQ+/9uHuiome0UqFwWAMaQr12dz
         jejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780741230; x=1781346030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rI4D0m/tct5A6mLgdnGzeGFfOZi2MuVNzAsWtboD2FA=;
        b=bJEjHyKsFTHQDx5OtNdYblRxzvP6MFXMqxVw5OXVVWvv1RqmZaUlB8d0S2G0/k8gh8
         L8/TBDg6MuFQYrYBSpSpyec5f3UF3oRwhbxoWGWSyZ5Pry0X02CkfM18BLngoUSlKKul
         l88pswxlpgs0XiViRX0dXrFztRuGvVosS5eXjgxKVvp+CotAP0Z3EIJUfc3AicASk+CX
         ZHMbzagTO/mV/4tH6LFkK0BujRhsGuzAOhroPZqQ2009+QTLw8wSPsHXLSJaral6f8SM
         eB5wrddprUM2onSz+o1mlsWd+v5vSvmoNhY6+yHI7zTwVY+H/zZxqGNPK9LZlR5ZDBdn
         Zi+Q==
X-Forwarded-Encrypted: i=1; AFNElJ8zXYA1NaNp1dlWtVcDSfn9RrgosyYQEVwq5U5YaPIUDdmRU8FjWs1PuppXdSmVDoYimReg2a8ytQ==@kvack.org
X-Gm-Message-State: AOJu0YzD33uztXOZghpNu2O6wX6oZFVsdTofo8N4RRJI8UANv9zzR62j
	AQgdRX5aXL11Y9M41UONHMHSgsbMzgOxAZxO0MlzzxCufdugDuW0Lu91xvat4jIGzw==
X-Gm-Gg: Acq92OE6jYR/7rPsFC68hc7rRYyMUyQytl/F/nVyDAm64PN4T/kxRrPjwu/ZcTTRyz3
	7dvdoTmQaJptjKqKrSGdFORQTvVEXNzL2Gdxu8Phn9YIZACEjT8/TcJDNBwftlDQ0rSeFmesmLH
	i60ETNd8/gt0pBrqD5d1KIESnSqnr9ayQHqroVf1Qs+cjdpYPs49zbKbOnbtqkzsDtCn1QP1XbO
	B/gqNc9EjZM5gjpXHGaRDztWd8v7h9SHueLm0pz6ar2/y4I5tKeSJb+z6HTadPbzy78+NOf91Kw
	dr//LFAbNqSXfwqefJWGJOSY/NtPbW0eP/S3hyMuPsaNO0oBNivNd2iiu5ihwBU7X3fkrVPM63b
	cFfDQxh43kaWHdpj7tpsL3TTe/kZKbOcU86MAwyN/zRpRvAHqFZiPVnm0xR/DlFykNk3c2WNpYO
	J1b325CZHPd3CUDKKMZpnePFX/rXHr8/RK9+WosrQr2xJs/6cKrjxN75GLMZs71oCmVTRho8c=
X-Received: by 2002:a05:7022:671f:b0:137:9ab:2cb0 with SMTP id a92af1059eb24-13807ce58f6mr166369c88.22.1780741229038;
        Sat, 06 Jun 2026 03:20:29 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df349d8sm10350959eec.22.2026.06.06.03.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 03:20:28 -0700 (PDT)
Date: Sat, 6 Jun 2026 10:20:19 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 04/12] PCI: liveupdate: Document driver binding
 responsibilities
Message-ID: <aiP0Y_7dQWPpfS5H@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-5-dmatlack@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0193F100003
X-Rspam-User: 
X-Stat-Signature: 5saou69a5p4f7gwyj4djxi1ttki3pk3f
X-HE-Tag: 1780741230-61146
X-HE-Meta: U2FsdGVkX189nHY9tzlzCAXZD04nyH/8Hjs7KdavxMjYMHHRhkv4I3TiIX/bYK5kvcV56ZxZa+Eky9gV2Dr7scFQ8+jI8EdpV0WbBjCcFmuBOA2ged7jkEqlcc70VlF2bPgROT9WHGJLB29pXZ6HcShbCY5Ee/UO+mrT1qY7r8bYuA2VKkni5uKqOvfGF0BWWdQtLwUg36DaEPrCLpTke1ezoEXPLH3Cz1XFMCsz41c78dzgHxqyVte6pbitoce3z0NUxiiBrbW6AA9/o8CvZHrFkmABXpuHvsToBhB5KOYiWyIrogi549ybQGE1V/bNuzfJ3+hRgMrzpvDxaIEurufGHlPlQjTLpXGF4xB0gglDqJQSgsSEtM1ORTukdyZ0Ygewvny/aIgFZrDXb30djCGG46dFun65nG+k7eWStwGVBu3zjXpu1txDu3jsYZ9fbqrenVda6p1EhbnvACLpcJM4cjVKsGO6evY9lwoX0/gLhrHfJ6MvHWjI69q5XakchmSbIAdLmmx0LwIWHZDOPObdcMvTBAm4QUWsEqWORaZ9EC5nrbXMUPG7R5J802CBulo01k5hgMDtsAzsJYwOVS3kF0ISf6LjrX4ufM/Znm3RfX4huuk+dPeQnZaCx1l5nTYtjzT7ED4w4nWWfx14bOqgScFbT99rKMNPjdy0KvIfzkO4Ah2WvW0wBnN5uVCeSOjuuCTwgnM5JvhsuIixGVEazvuzthCNCLMV+FK8DBx78Ghay8JQSQ0Hl+28FHjKUbJY7vJ1Mu3OEk0TVg0pSmMwZcGnPK/DcTRAqO2mD+GY9nrdQjOgyasywB6+ztDYT445Zp4sJCOSLt2zsRevQmWrix6hyUPDiR0nkOJ5lulsGH2WlZ2/eIxjkJyvxTqqAhPQzjv57I5uwtJcCCuD6r3H0PPts+ANKBjYAv2OQh0zl5QNjqYACTLPnO/+6A4I0PJQbWwc3rYE/eD74BW
 hOAeU8L6
 z+qnW8Si2MZG0LgyFhWsBAYHsFB7PUKybJLOIVeGuIMN38hyd91H8CC2B5So4yn/wD7K/a7C5qKB50/5Ep1VmT1hWgJFM+rZnHr6v+4LQbhgtxlsT3E0rsNp8YfyvrxLhlniQguKIrSxbNZr2KGU6m4cGmvzrqIHGcUCIkhZCQJuBa+vpjtQcOx2PmDlTzWzOjwjtXKIcOrhe5wJBV6cAxHgV/z4S44TIHL1ZIYhfK8fx0/I6JoloAQcUZjva9yyT7mw4QHqGEaODjgGAuVGFqlgW1dZIgHObHPioDMphTBM49+R2zRrn4RJL6gwyq1Tqnm1LwaABZexPzSMb8KMUNIz9KlnQuecdGs9B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:02PM +0000, David Matlack wrote:
> Document how driver binding works during a Live Update and what the PCI
> core expects of drivers and users. Note that this is only a description
> of the current division of responsibilities. These can change in the
> future if we decide.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pranjal Shrivastava praan@google.com

Thanks,
Praan

