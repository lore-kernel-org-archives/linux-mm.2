Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78E0C44516
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 23:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9DA6B00F0; Fri, 17 Jul 2026 19:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BE46B00F1; Fri, 17 Jul 2026 19:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949816B00F2; Fri, 17 Jul 2026 19:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67C976B00F0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:39:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03727A0274
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:39:02 +0000 (UTC)
X-FDA: 84999886566.14.DCF0F78
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A48418000A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:39:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a4WhAzAN;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784331541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOQMW/VMMZhI1OvT3xpmRY3tlZwPV7fJgB6bntOIi38=;
	b=lVOxvHNtOh3calWlB45PaFohDKXhwBIsnmAsN8PCj1UA75xli/3w02WMdbNhR3MWHzWSCU
	JlJRRA97xGQ555Vsf7Huem29zVvWkuFx9odYNZcsY35yTZH9r+fae66/b7NqDG3lhdPlQ7
	+0Kn8+zn5TIZxx9zliWmdRSA3g5ZKNI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784331541;
	b=sS/nLafImkmYL3B4a40yJfYtvvPBi76svIL1HNAv3DSEU2sl3/eHmtcvwmMa/GiKcUaeZW
	cAcB9yVIZTeYO8hdPz+YoxbH/4ubCWftXQFEGQcacjdP8xNCz2JngPWEYHAxcscQg5u8s0
	TuhXYvnZczPq9vpeyH2uK9mSjysNzVc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a4WhAzAN;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-90004d2f7b7so107926626d6.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784331540; x=1784936340; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jOQMW/VMMZhI1OvT3xpmRY3tlZwPV7fJgB6bntOIi38=;
        b=a4WhAzANtZ027JBaBbGWpvaDtZh5f2gjDXX/0drudBP79/GLaISjWR5meuHZQ+4uoR
         52tNsuNrQsmAbW5+xSocPAkz5aGkZv1zVdfg92lMk9A7FhXPHgSc2TSeG840Yr1v21rs
         uGub9/HnpVlJEmYw8Fld7BdWmXj6z4ow78gC5OGJz3AbXnmngxRqOPKpgwFDB56mMeqQ
         gF5mqN5lNUtB/eo63Jrv30tpTB8o2EivV0kfOV1mlrkNRiUGk1akUUi0sZvPZcz3lq7I
         uSJYnoHAFRBdRs49wYuJ7xRjvyNsw/Duw0YsESJSYF2eUDXGmP+QEGQBbcFaHwebw4lC
         bb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784331540; x=1784936340;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jOQMW/VMMZhI1OvT3xpmRY3tlZwPV7fJgB6bntOIi38=;
        b=saqj4Hgt/sy5tjAWDHCJGHzuP6nD8D0rUB1PelITsJdl4wFgZkaw/puAT8ygLlPKcm
         u6M6ZUy08dp2nCNjFeQpNKBuurs5Ogf+txIxMm0ihewUTuhGbfe2guxYH2/CaTysoTk7
         7iS01Xcn6w+Oh41SkpfR57G2HzmvDnJR3XEU1jEt78keesWI6KWV/WwoT8snHOu/pHGQ
         dq92dS+0Lbbs8SBSq6gQu6cu97JW61i+TmY+qNeYAukHMB7yVkyCx11ApZJJISy/rpLg
         VxTlYwyQIHrBY9LgoSt535C5mlE0GqYUOmAZ8+SyhT1CpE/l7iuOgjk2pKzBDkCZB5K7
         kbnw==
X-Forwarded-Encrypted: i=1; AHgh+RolnVFzP0TvJ86pj/UfvDMjT6nPrQZVrCT6qbRzW4XIuycKEurBi9y9emJjoVQ/MOtbOpNN6FykLQ==@kvack.org
X-Gm-Message-State: AOJu0YxwyxTL6a9a4kSZKUxSbenRJxAEIon16xIboxR/KLxYBRic0Lxx
	AcRj17N7qRjE0aj2A3F4bbGdLSmM9REPVp0y1tusa4S8r/yjeZBmXP+v42kpaym1p6E=
X-Gm-Gg: AfdE7cm9UBxbPROh6Ltp4hHOqB7z96nJbgTSxtya6QIBlXsFl+9fEfw3F0aqRQLsudH
	ZrbMQBhO36z+3rArmChv1GGlmMZ64UM5OWOjQMk6aec/Sn7rdHCLvdrbliickcPeFz8JHdkzlwb
	RuudprBPrZ4HMA1p+xXUu6LHKRhlWxEAz8K12mXcaLUv6Zatr87NA9T804vPExa+NqvrOjLJD0f
	cMVBaeAVUTaW5QL6dK0JrSoRBwkhjwUEv5RJPtBnCPBZEvp7Rp8hvHCM47EoYSIJwDQJgEKYIt0
	8/N1mvZnCEmL9oKNjDdeDlasYY0zR6iqR3DZl+ng9W5VlqlF5h1gFgfXC0Ga+X79cB0g98vbFpB
	/rAkV4HyXQNu+mlV7uJOtFDZ7KDtp48CI1xAaPtY+J6QQ3aCc8TLW192pI95GJrPtWMCm6pPTlq
	1IOmHJ/I5bBlTji5LOtObnUXcTuY9vHvTvAWw+u1o=
X-Received: by 2002:a05:6214:5d08:b0:8f2:df9c:3322 with SMTP id 6a1803df08f44-9077832dd0emr59277606d6.14.1784331540051;
        Fri, 17 Jul 2026 16:39:00 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907786f79e1sm28353026d6.38.2026.07.17.16.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 16:38:59 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 12/12] Documentation: PCI: Add documentation for
 Live Update
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260710212616.1351130-13-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-13-dmatlack@google.com>
Date: Fri, 17 Jul 2026 23:38:56 +0000
Message-Id: <178433153669.189683.2878214157071313722.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=873;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=vSoFj0hBTT5p/CFJP12khF+A/hWJ+rXJdU4yKcto9Gs=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWr0SpjC+L15xuM1whuQrxtevTro4lUduG+wQx
 gZjJKCgnxeJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalq9EgAKCRC7dyhM23N6
 3hr1D/9oIctf3jZFaNFf/Pf9J2Q7CfddVWZ2nNZ2arIAM0OUwhaxiAs+LtuvHStvp4Lzy79OaPC
 MNsK4RZArZ79NaLPOR9S5E6dP8SihdNKm23FpYWS8kmNKUvlpnvUn96H2Bo1thrOScdtHk8KXo2
 7hSeP/+8USMLy/ZHr2ShtiB+g1UAd176dG+ifwhSmAAgPmd16B83riVzBB/kFOwP0PXrnOHWCVg
 NoyCSnhFa7Oj1iHgWlBLPNUv1deka5wHUy7CtHqHc73wIsD+RDeq2t9Dnauotw051GQYm18pWKa
 Ro4mNfaV4/bgXOl+EindmOYLeL4vmRfgF/9ZiKkyjLjZcj7FGt7HsIhCwwbT/u2+A8OkOyGoZYi
 r1Iwow+abKmLmqHeqRIFjne6kQTJb22jxEEb/ezTHqlg26zjd2K/Z1L1frMnEuyd/6lmTpda2my
 KRnfdxmtZtL9QDtYOyUNtLuaOuwzNTTdod6HZcSVYGSUrQl+jbcegXb4vAnwsS3vURMyxjiGKME
 rn/hi18xZaZXcMv99T6EuayIMn8QHlfKaxv/XQG2mzCxdePpLOJp5QQlK322veGWDifJAyrkoRP
 XWQu7Llfgoiq2whZiWSbBSEkh55X60dfTNM06+VWWl86F4nrUoLaQGJti/70J124jfGNFISbW/A
 zR5q4Zf8lKCRE6g==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A48418000A
X-Stat-Signature: sxgstme53im81u54yhf8fwpu9gqxhdkx
X-HE-Tag: 1784331540-272265
X-HE-Meta: U2FsdGVkX19QvqEVxLVLoxlWy5ZBuW7Yd5GgXupbeqhD+iptJirNIpj4EA8qamvIU9mGbuBzLuie/wDm3hzjRSx4zJm6H4xJIGZ9BdjeqI/zVuYCienws5i+XfLQ8zuovUI4G/KA7n7XbZ+uwzj2uVrszUnbyup/MoUcrHLA6BE5a4x727bdJQDtt01bvqPfNOITsppUoL36A2YFkrzyW/KqLBF1+JIIBWPSYDoygfFAWTWuruGCheG7yAoHobEzhv8hLWNb98PGvpJes8baL+G+dP53AWNaJqCUmST26uXRgR+rsL+0IY8ey4dklCmzb30ZNuyGcA3YBWUx6/XnNX9GXZPtB4+LgKzTRRqcuP85Ek0Ug1TaSr3fCtjY87Rnzts6qZqjWiT0dmvGYD1t1hm7yzvGwgFlgtOuu2J6tpuIZ2CXZJ73vcwhzVNwJCLojw86+yBfS5ssmSA/aezWlzlYBPWSqSQnTfTgN5YgHQbdDK0g71Zj3mTdLa3twjZCB19aGnA3Xg3Smw2ReBvm/AwmA6N9pC9NBm5PbzUqP8wLFS+AaY2J0v1d1IMGkSFVCoQTBbGYHlmeoUUnVZ6q6503eNkxT1gYDTgyjbIqvukY6TYAp22wvISHJlnCuC690OVI0ozUnoYGG1O1dMFzGWzuW5FaUAssQCB98ILJr+oHXv1Yox25oDKCUAVYsRTObR/iss8r9cqWoufC9m2wH82XfR/4BWa5rZb/u7SYiu5zI6kbbEA27ne/UZ0mVKmu2uQoqSxndxHBrSzcujrE8uDjBPPWsq2BVKAKMxkvJfNkmII5DZVy4i3NHcRbkGWd3KmgGpBFguGy/r+EAoHo3lIicP9utMkSbEahhUnvT1GaYgeqmqNttpqZWjWZwtZ8vQsgULAWY0hrUmjQcpzbX1vzfG1sc+ztL/iBsPfWzgjIQcA41HhhE7WuOXt5nN75CDLsqnSJtS9/ZPOldxa
 0sW2tO4m
 YctUv4ghluhnhXlqet1NrZCLqm0i6614mWS5aMaaTuNT2qzTyR9xURkwUYRkV51w6+w/y39d0c0HTcVAGKyWvm9MgqzwxEt/kSk9uInXxQI9BBU8OtWHqZcuMzG0agaHoAZJSQAL9S6HKWrZ3PRQn6BPIXE8H7MNM/8CRkU3wqrxbTlYHvdkgyJcLEhg0Xi3kGltNXch6w7sRkb3HK9Hp3nlaYOx+ldIIGSjzGMwTNDut6vX/Xrl3pq1RmLirzdznf5ZZA5byR+NGTTM7Kz3SSMzAuBO/01ylm8+JgcWJacKh21lY7Wj0PpCjsIyGg557bczIftQaOpzIzbKRqGijGKA8a/bKdWXythqPdvhRyIGFkdo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:15 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/Documentation/PCI/liveupdate.rst b/Documentation/PCI/liveupdate.rst
> new file mode 100644
> index 000000000000..eba55f8a92ae
> --- /dev/null
> +++ b/Documentation/PCI/liveupdate.rst
> @@ -0,0 +1,29 @@
> +.. SPDX-License-Identifier: GPL-2.0-or-later
> +
> +===========================
> +PCI Support for Live Update
> +===========================
> +
> +.. kernel-doc:: drivers/pci/liveupdate.c
> +   :doc: PCI Live Update
> +
> +Driver API
> +==========
> +
> +.. kernel-doc:: drivers/pci/liveupdate.c
> +   :export:

I think you need:

+Internal API
+============
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :internal:
+

In order to include docs for structs such as pci_flb_outgoing, etc.

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

