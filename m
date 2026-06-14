Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21462CD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 13:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA1B6B008C; Sun, 14 Jun 2026 09:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB336B0092; Sun, 14 Jun 2026 09:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A946B0093; Sun, 14 Jun 2026 09:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B21C6B008C
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:41:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4A81165E11
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:41:22 +0000 (UTC)
X-FDA: 84878630004.04.FD7B91B
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id E9B5B40007
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:41:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Amwjalmj;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781444480;
	b=lPMSoeFsEp6pvK+Fc/cWcx403ZUoXaofmBPemwpO3zZ69FInMNpW+326w81afXaWFxTtII
	ylAkG7QSYlpJ713LcmZyR0+MGuPWeD7DoSuAwGrc3niCUxxt8sdu4Wyjk/aHrzZhICiS4o
	TH+WWR2uAuu9SEwmA9dwQVmy71x16CA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Amwjalmj;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781444480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeAw+vIhY6bA9mSRruzAQBCEt99MDj9JV/iQLow7qBM=;
	b=LmKzrIxd7sT/lP4yG8U5FbbE0D0PefJhMpUmJh0SUGik4tEDrTGJU6hYECmX+OkRDYEvS/
	P3+NTKgBsxoKw9FSXT+H5agZima0VTIR6HUlN9IKzXHk0jAXkTY7dw3A2imm1zuw0BK/dq
	IzJ3/86ShUTdQ3RyePm1SedI8qADoW8=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-915d64fead9so365332185a.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 06:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781444480; x=1782049280; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeAw+vIhY6bA9mSRruzAQBCEt99MDj9JV/iQLow7qBM=;
        b=AmwjalmjHVCbuUr0+XvL+RbJiR/jhRobjO9Ijo23FRxjYzGIahauGEMyr83mV4XsPP
         Q/fa0xmvTOVhNiEe5mtcxJkFYldKjaBqlIaJQBFO5n7ZHCtA6bXh3UKp0WcrTU2hvSKL
         kgNPb7Rb3DdrTPjy0fkK3YCR5+BQra4oIavLyVxBYVG+iJHIfQie2+IhBPbL6MPWbl+9
         k819sqor6i9QNcZeylsBlOZ8K9uCMHPbbSaSzyhRDVIaJz7V0is8gDhp3J/SAAYITgmM
         veSOkqVCmb06iCMnMK8KIpppmo7754ESZBmfrQrE5k70NH0dVBkbcPQE6LTncpezy/Rp
         h9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781444480; x=1782049280;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZeAw+vIhY6bA9mSRruzAQBCEt99MDj9JV/iQLow7qBM=;
        b=LwNTjjJl62CI4nAEH7Y3aCPBOnjFeonRmIDEOSM6jlnuciQ3II0FZYm0nojyUfAVMd
         b7sIJ0ZZR8TEJTTEdV++szkgzT/aWZKr2XnEySNTqHMfyZWjs2fK2Fu7DnnPFUBStba+
         hxZzWx4feb3euELw5qKqPEV0epXyHv6PK1KgAVE9gVWT0XOxOnj4E9wLM/ML4ecTaP3p
         bYPHfXcT0v7ml4OxDHGRG+ymIYdYENMAyJl2FRHuj6WiUQ6BCbkKLcgt/AXauVCbx5ki
         t1Cf0E4MPkb9IvCaPy10imHVwISd1OQvxNnhUTB1njQRnGx9l/xG3SEdB4yBiRXG9iEc
         v9VA==
X-Forwarded-Encrypted: i=1; AFNElJ8Fa2tOKBHNKQAktI/x4JjrLj33vZcm2nG77fFFQy2JDRxwcejn5Bw105cwUT344rEPoiO2mmVICw==@kvack.org
X-Gm-Message-State: AOJu0YwQo00CDkbTV7ZlIyBZVcVhcFr4fdl4upHKn+tZxcehR1DvNZTk
	7K4ayegMqLG5n1CshFjC1Yjd88bPJqdLBGvP8eMYX6cRRt9dzClnCepPN5oaovuczjU=
X-Gm-Gg: Acq92OE4S9CPFhw9lMWUuJEMyv2FT2873xKlk2mVFgyI9VvVrbRGZUsQhIVQ9cBQBGI
	8uQfv/Gww7zUwE2KM6h+rj2PKWjFV19O4dqCUGJVMxxB/ZcUVlN6D+l615rMQf6ESZNVC1ENh4n
	RplXOVtcpiX1pVq14ngG0v78LxRDh1B8kXI0g+JpLr1+pMLnd0auDeOiB/nVlIYyRswY8cssjqU
	PO+OgUrGBjxcJxpFW4SlnP0Z9SB1J790RyZnfIqC6NVp2zB2Yk+n528rjuV16aEk4fIOdwys9Gu
	JJd05f5ATZCCvng06Tre5dtIffxQdTraAM9p/n/u+voq20SiNdG6pDLRK4YMXY2RgjF6pFNKkJc
	jI3cpUKdJNvlyq3PFfsZDsukWslDX4ez+Oib7YVtF4bDVjo3eW4QEyDn5pCKzLZpQFbo+fzWqq8
	THHPk62cCFIHHv9/pqK7p3Rj1JVX0ABgJ7fTw8CLwQjrTGAoLaVLmjnaNQqWKhyVvV3uXOFjU=
X-Received: by 2002:a05:620a:284a:b0:915:80ed:8327 with SMTP id af79cd13be357-91619f73cd3mr1359281985a.41.1781444480052;
        Sun, 14 Jun 2026 06:41:20 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9161a00af50sm804255185a.30.2026.06.14.06.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 06:41:19 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 04/12] PCI: liveupdate: Document driver binding
 responsibilities
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
In-Reply-To: <20260522202410.3104264-5-dmatlack@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-5-dmatlack@google.com>
Date: Sun, 14 Jun 2026 13:41:12 +0000
Message-Id: <178144447224.1257322.6028717050680465656.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=436;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=9qCCo5jqZNYTFQYhvn1w10HthvCojM5bi7HQ3wIdz0Q=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqLq9+V5ehmqYdW7aqY5UC46rzyaBztHZtTXaEV
 wNq3cD8aFeJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCai6vfgAKCRC7dyhM23N6
 3n8VEACd7+ln+qHdtrY009zcX3HQrr1PUWTlugPorIeOn8XmTJbgYuCm1D7mH91o1Qk0SZe2+wI
 2S0wRpAHlKaOVEtO68gKBmhZPDreEUWbyJPh2baoB7PEM0rHohe6beLyk9a0EDGyMoizfUQVlBE
 elPL2YdcMN8btmVGap5fkjrisPb/6OsmU2lUYZ+KNnAx38aUZVcUvKDewIbq25zdwlZBUKGecSh
 As9pDuvz/CVYl/3F2pe1wWh3q+WvNwNasidlW+NrS3zSIJVb0xbHv2NXEnOUJcJ127swxUuqvNJ
 Q3siNX2gD5B3zi5rElvySm4JdLzs16A2WhlbSrwn1B93becCXOtZ1Opap0noIZ3rbnK57eIq2nD
 pYRAwOqOK5KN423EhDkvTAWZGYyxMC9vWQBfaAa49JbYobhWtvnGWr1ezCJ8k8bEcf4RRLYXcoN
 8xYz7NI1pblzXU2nq5qcyacPiWBzU90F28R3+LuI6wz45GMTbHQZJynLNwaWubYDsQjEZHym77Z
 X+89BTifV4853SOCW3d5PdFyp+NqcbzEkiRaNg8G2v+FxPzIY5B2QAbioj9U4pY8gLM/BoLASVh
 xtPEpIr93n5If5K9gYKxSJDWp2YDmXIBrR1LD3sDnJ+q/TjpSVubUA9Pu3yUcMq3lQZSfZeqnKo
 h5XFZvHeHeKTbBA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9B5B40007
X-Rspam-User: 
X-Stat-Signature: foi39rira4qs9jy9jsksdbc5rec1r1j5
X-HE-Tag: 1781444480-911489
X-HE-Meta: U2FsdGVkX1/gYZXc/Q6A2dHqWcZcHFrNAwU208/3d14yJcJZWoQxhHhVTPDp175KyfDxWrY9Eh4rp6j6P9sS2BB2DvCYJV6MrfFs7uW3Pz6UNe/tEFZIk4g34a/b9ml0fvVKjXBMS/n2lsTIIMgYo56cERzjUfc4iiWrvT/LYs0e8615dL1ApsDOqFEliTcilfLD4lkHT4pUZ6jXQ+H2jvExdEPTTJQCRT7ae1UfO9AZBrv9m5vsZ9u0WC+BKRmQ4ResuoE3bNlFxAC8URV+CSwkMueEH9uy/SwqG8Sq3v1Mh9nrJAbuaadZOJ0knjJnh5X5epQ38vl/cW/jxAxtZRY/GXR/N2WrKoFsV+Xg1hUW7xgGcwxvQeAGIDSPFIDU2jWicDEqH5WUQ1cs02oyfwG9qpU4M9X2DLIGuuNG5Z61TFleYtBD/briBuUmxyXD+OWk+/8luJJTEunsTk1dsiysBvz1cgiTMYF0m55LsHm1RhL9WaUInvZp8rscg9k+EUC7rLlO5ffm2UisZ2L62XwFL6ofUUrUdiIA5ojc5qQ67eY3g6xGZsfwFi6SYhFerGjLb/pr0clWty9SNAxLaIXDbuTz0n8YOYyjCw1u9TbUxa0CBDro0JrwS5IWr6DuKiSmfTuingz9u5+pPHHNCjVSA+u6HAIv/UWGgw4IjClfMgSCb+KE6Ws6eBBWuCFxZLEeU7xL6N9xboLMZFPLO3QrysiqKd6wZ+l3mhvfifYq5kaIP7zRqiZJzrHJNBckimRvkLoEqYWEeHI5IcbFZJyVbugqKi0XC3nsxtyMTfC8U6yjMuUMPpf8FneBslVNSJ+/iRNGHjiuk2fF826c4qnsGNBlDasF2Fir+asxqdPqz4ddasDEt0Zvea1YTVEh8HtiJxPfkkK6xBm+7ZFKUymWZIatHST8I7k8pReOYIbE5PeF5t07z9jGSCWOxDvIMLZhxjIpeQw+3j5EC01
 BPNtBQgF
 3PpnbIJB8ivqE1pDwDA0FaSV46zNgYwezqtQqECupClzQvw4GaSApZ79vLvefHCbUU1LxIcSOZKNuvP54ygekRmUtfaiqHndFrHgLxILAkncSkU7eKzFA9fjcrjJBLW/vUOyRDA1xPKJZvQ4zzPdWrMZipUp++slFbqEB6gk2XgTTBCF9tFIFz7DpTqlfbAV4JFCr4koQQ8/+/I66Rr+E24G1gfJ8HPD39eKTTMnJrGYm5mHSLdr+HrlOlZ3/n8MOgoCiQCrS6CcB1hSWnif8VApVmHfMJTeuCaxrhAAX933JhKM4H7QbsVJ7AlIUw5vKi6hT+KzudzfEe6Uv5ZqApeH9Ja2BRzro5VIz5u4UZK7DMb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 20:24:02 +0000, David Matlack <dmatlack@google.com> wrote:
> Document how driver binding works during a Live Update and what the PCI
> core expects of drivers and users. Note that this is only a description
> of the current division of responsibilities. These can change in the
> future if we decide.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

