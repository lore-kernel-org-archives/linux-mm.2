Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F827C44516
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 21:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067DB6B00CD; Fri, 17 Jul 2026 17:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A1B6B00CF; Fri, 17 Jul 2026 17:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22FD6B00D1; Fri, 17 Jul 2026 17:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 963B96B00CD
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:48:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62AD180290
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:48:49 +0000 (UTC)
X-FDA: 84999608778.22.589D30A
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7BCE320007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:48:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GUoo9SLr;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784324927;
	b=kUrUuuIB8r1CjdghSXcNwp3pK34fEStRbA4xaAmOvFkictqry87mBmF0jg63LKtXeTV2Cm
	T+06+Ye7hp0g7xwURUUQ4zR+uSkowytqsqBcTx7ebe7XmVf3eflc2J38uXZ2QhLR+6TdPn
	1oSPFU5gn9kG0i5Dslzjm8Q4TGAN4dQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GUoo9SLr;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784324927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmfnNFiyVA8U0Zovz7XobfQoJyevheG0HUiwPSbCO8g=;
	b=bWSl814wT0n8m/YcJXTdRYFgxZggg2ZdH1YJlnK7qvQ8VzDtcc7kiguF6ZlUhU6pX1jyFo
	creiuh5sfpskETwZD0ZdhmH/P/91uyShP9L6N7SW+UbQRTaEmMwnTSwxFBKglDxr+FaLBT
	pdeNKpx8vGUynQMWtg2tY4KfVVi7cN4=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8eefd0c5f59so50953686d6.3
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784324926; x=1784929726; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zmfnNFiyVA8U0Zovz7XobfQoJyevheG0HUiwPSbCO8g=;
        b=GUoo9SLrq1eE/mWeTRPi+2alxe1FXpkJUM3B7NmPskCeGHxPuH86F5y6N5h8FfiYwa
         tZqImZE8RsnMsVUnj2DWGy5miudm6rNrdn0+tfQHIh+h3Om9mQwMfEc6dSp00/98EPbR
         UETChBsObjpuRVe83EEShioU2cb/ekuGlauMfFHxYIYmiMvuIakT3EMCkeZ5wjk5cJZN
         3XHPAYbbOXDP/Ca/Cqf6hJ7KvDsnuRpbYdhVs3uw17aaPqTQeY/Fjwe3RH5kSFnonhyl
         Mf/yZ86gNWkoibUX3JoiWCXekivVJUPRL8dFmuZmSeSV3fvXCAm9iTQNynoPrhgetELQ
         QrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784324926; x=1784929726;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zmfnNFiyVA8U0Zovz7XobfQoJyevheG0HUiwPSbCO8g=;
        b=H79Abhpjkps3yqoueQYM4YM8q08HdCnp7zgnNz+jBU3ZE2WIFqcMxtUVCq192nB7VP
         UK/Qy3+FWPMUK+BGzHuXHmMigqHs8pX1ZAKDQZsc62Hsjb1fadEJtGrvPLTrdqiV7xZJ
         Jf9xCO5YpMx14KdCwYV3L+/IfWgaxF79OC7O+T6lQ1O7jyOdhrEHOVV/bfMRiSYWGYpg
         2039zBlrGlb2v/FJ4TaEWlvpFg6gXceUTWDNffgc2nV5/Q1U8Qi18dZ0E60nPYKPrAhp
         qvZRCJGX6veHQgQVLaavQGh6C9wEHtraX9YQ9qpHaw+kfHfxtkgATI59RiQg1ltM2C/U
         xbKA==
X-Forwarded-Encrypted: i=1; AHgh+RqVnKKTSUfD7nJArZy87GPDrRhFzhc+sVCTkxx68o+tiHk8wgKMzsdFVBkOp00A7j47PSqklO3RPA==@kvack.org
X-Gm-Message-State: AOJu0Yz6CXZ5q5bLccIXfYtOHXoBv2HHI8FMp5E+d3480Y8h3maV9ZGk
	9lNhDOArXykgAKThWo2DIXpxLb7JEWfmx2IrFGzQmAWYhz/4PPYnyhJpaPQdkaqr1Hc=
X-Gm-Gg: AfdE7clTQQPQZ13fz+z21xkR65dThYvyDlZExETx+Uwc0uDWF/EmryYUZa0fjKHZcZ3
	76uc7zh/n6fxhojkey/AjmzK6B6qSoqw8D4emBqQttymz9t6hBRwaCyo5tiXcKQvN+26kGoj9gq
	UyDQIijCJbm6QwyfZQJuOFsGq2kqlEOP9cM+BroMcIDe3nizs1TUiK4FWfXGkDqsiUGFrtNgBem
	Yb+oIpmn3t6A2Z3cJ9vFzVtujCILBpImxeRGJNCcYyb+9C8e5NI7B3LpdCm1/lvot8C586RRTZj
	Pjvplx9vIovMOpsrjKLTE/ZV1m8+yu8mVG10oxkalEyIs3nDOk3UtQBWifEVTmrag6roZ29fgIx
	wLvnrz3ep5Oc6Qw5ji5LAjZ5I3MLQGcgVn84s5CMJL6FyzxBy5zvyZF8hLkPDCXlUh6gJ1M+DHm
	Ls9e26NMZWrMmmYFZgxoT/0kIYuKrTVwPnFBcy6uM=
X-Received: by 2002:a05:6214:4284:b0:8e1:694a:73d7 with SMTP id 6a1803df08f44-90778380e0fmr48191416d6.24.1784324926660;
        Fri, 17 Jul 2026 14:48:46 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907786f79e1sm26338696d6.38.2026.07.17.14.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 14:48:46 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 05/12] PCI: liveupdate: Keep bus numbers constant
 during Live Update
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
In-Reply-To: <20260710212616.1351130-6-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-6-dmatlack@google.com>
Date: Fri, 17 Jul 2026 21:48:42 +0000
Message-Id: <178432492211.189683.10563224295975168718.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=934;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=496HIZ5NHAZVhZ3LL7qzsW0iuwhuVPP7StMDlrFgMMk=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWqM86KaHlniHcC84sbvvlVrTWaav3eU4iNKDj
 SHnfSycZhyJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalqjPAAKCRC7dyhM23N6
 3pAgD/sHtZxz2X4+/Faxm+h83v6Zqb8OrDRH1Mq0Fu/Ty4wrIDO9AUyUsVw70fA/N2MvHxp/1Xp
 KSw01NVB4QDW/o8OkXnordoL06ZSPy/CN8pA4ibrtaW5GTXc0HvVn9XjzLb5TpkRvVQUFoDZlNy
 xqZQfN5QkA5t46L/QfCx5fVPGdFvvCf7gpOQ3aPXbygWPYWSjBL7i6noJgIm8o7tHCxqOCtmJpS
 KLj9FwZbnQrxac6ZagR1+sP2hfHfTsL07j8Xkw3dqdwDw76uuBV3ulOvMvLHk3xJiU8BQmb57po
 lsovpsci8MA+2Nd5qdOYySDGKbbyoTcdUVGqI7ynPmbWL2z6/i/AoYW1JgUN86kg2moCic79wqs
 5LjPhY13xc59vZIJn1Xcd+9qdGgfK5FHgXJ246tswyKVxFHB0Fom6tFgtrU/3QwZeD2Y9dcSZwd
 UJP391ZDKWNhdRK1FDFkE47jOg9y93FaurAyMhna+kJORxVLU814KM6CtBCoIQAwjPE3q+SFwKK
 74v4OBYVRxM7McuhNVOnSHLnObJdMRoYfVJheKPIHNs8V60mCzqr8vQjLPpQVkTZWWxup01Mbxq
 yaOhEnGzX9FrYRbdujMNfroiOD9ejkFN1MRBE6SzdTWb4+cRb6JylvfqUF3OT9qHkmHG5WBvAYM
 euocaROZ3nCR11w==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7BCE320007
X-Stat-Signature: 4pqf3wpc3m46xhpd8uik3e9anrj3cmbo
X-HE-Tag: 1784324927-450674
X-HE-Meta: U2FsdGVkX1/hnMhpaV4S55bAFbMc2V5WxlTqSC70dGXSYRlNZkYRQ3B9rgmgMVqfPzC7ndzHrT3ZIrcst38XSqx+v23jKWkVvieF1Hu5SNBVj/8G/WZXGb9LSO26Hd27AVRcQIhDmezdawIb2hQt3JUBsKLmbskvSKKUro9LWqb66bSN6HGlK68AbXWvnmviNjCo5hXohl7vfWgWyOCQPXWV8WTkfbEnDa5aAdH3bapzPAzy19NbG8SatewogX1p43cAfVEY45uZgoaQYpU9xYMWCyoWHxNhZG8LYfA4/jAQJiy0JDfOOTaNWXQpJk0cLXeo0nq3+P8utQoAoPc6/4fxrs8kvuCK6NYt1ZTp9cJo0g2jH+gE1w7yG3RIqQLBY/f0wCXawyAiZAAUjVyDgh0l4/mmUqo4Z+O9BfdW6Vb+SlQSjUZrc+umXOxmw8uScaaY3rWVgMmMyW/+2SvvqkK0hGN/R+DOXXGn3H2qZ80Fjnjw5Pus3+eDLFYTMFG3NbSTdjZr7y2+En07GAxwrSEtm1DlfLvElAGyJXYW5eMC0KW3dx1yLpBcv6o4VgUtiAmqH1LhC4d+EwgJBFPfCUTL7zeqwuphE3ATWKbR2Hp86FvRdfihmVuwcDe1omarb0HVhrkeGok0nnHc8jaauHeWjwEcbXwbciU/shTlqfqwzYC45cmJReZL3uh/nzTOj1xwFKvZJwD1uTbG/+6IrUeYk/m2Lsr9E9yNsFFPrzlWSSl60HegWCVsNDbBJx/Erim0jzEfYRhSk+Xmp4uhPc8fj9/Cf7/6Byq8qiodEN4A8NpdeG73B5Wq1H8BatSxhrfOwTHXm0JEH7eswIzLuGCGPP37cYkBJ8ouvAqnC9JCSWP7VvJMYIeNdEeUMg4JSNM3dUetBYQlGDHL2/GnZIbNJEyaIzIdnhmhyl1t21zOGY7YnMynjdobzyAWs1qbuAy/S3TsVp1z7HaB5nR
 TsyKiG8A
 ZLYQj3MVWNhiB4v2xXeqfmxpmOtu+glYgVLCAC+syw4rRwiXdEBdQRCibavaT9GBTV8Yo1ABfliq/RqLbJITAlxdnztXcUUerbCPsPi6kmrBNYDB8Vuq7X84s4FHXmBt+O1jiXwTGDnx82n5fxQeLvPP441C5JmkeyWAu/6hdRMMNmy1NYg+6sIRuVq/CCTK1drUjvX+zLtUvxY1l/4noZ39aIj54X/EOYk/LirJ6e4iUxB1EvhhOVIwWYmbtf/l8MEwrDe3PBNcAHVX1Rx2Vxkm94pBEEEsB9ucOACWvCjUrVvLrHGagFQFhaenuD/AsUFSsHol3Rl7pne+zyxt6UYajV+4fV+0YfH18PB2H183JARs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:08 +0000, David Matlack <dmatlack@google.com> wrote:
> During a Live Update, preserved devices must be allowed to continue
> performing memory transactions so the kernel cannot change the fabric
> topology, including bus numbers, since that would require disabling
> and flushing any memory transactions first.
> 
> To keep bus numbers constant, always inherit the secondary and
> subordinate bus numbers assigned to bridges during scanning, instead of
> assigning new ones, if any PCI devices are being preserved. Note that
> the kernel inherits bus numbers even on bridges without any downstream
> endpoints that were preserved. This avoids accidentally assigning a
> bridge a new window that overlaps with a preserved device that is
> downstream of a different bridge.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

