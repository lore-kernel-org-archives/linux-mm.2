Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C8FDCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 14:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C346B0005; Wed, 10 Jun 2026 10:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3926B0088; Wed, 10 Jun 2026 10:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9E06B008A; Wed, 10 Jun 2026 10:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63C536B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:37:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09589A0102
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:37:18 +0000 (UTC)
X-FDA: 84864255756.22.8307C8F
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2E646A0006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:37:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MSc8Az2U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781102236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hztkJLAOrt3y4FASh5Bx2C0OqdOIndw7eniIOKrpzws=;
	b=CiX6Dli9Zz2xt54iuNrsGD+GL1mzssmjYLXaZyL0uLkzYh+sTstxX2rqqlqDA6a687W5Cj
	wYb1vQQi1hU8xsn6EDpgguorQwpUyiB/4iMhTXIxgF10isCALXkTmrbV2X2JitqjbWkr5r
	MALpyg+Orn9tPOv9R9G3fWjxoLfbJEs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MSc8Az2U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781102236;
	b=Y9kWNf/gdlFdrUusW58KZzI8A/Zxx4x6+iQ1LJnubvKlsi1Y4DIDFKjKIZZlOL/rXrydPK
	nYr9OybSs6puhVh0vC5VbQHuCQ4L8g2STxVGfAO074bYOfczgCl5Jg8Ilk6Xv9JjZn0o0n
	4MKWekG9MVmIbIZl+mBmA2dF5k53G8g=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c0b1a48855so80995ad.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781102235; x=1781707035; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hztkJLAOrt3y4FASh5Bx2C0OqdOIndw7eniIOKrpzws=;
        b=MSc8Az2UJgnJhx/pMfA/CPL6vF5oohz6aHAvhDZ9g0Z9IpYH7czAoBXwu9bU52Gp2s
         nbAI+pO5n8BEjUDdgH6cW+6w67E/z9kBNBKocYirFkPgvyCSDYnKnIX/Q/ZG0TnvAD7F
         1FBVNPixB1kRpj9YPOx9ZhgdQWuMay38esW4zFvjtxmyp6qUyYkH99jA4CIawn3+XJ4V
         nAVOtLW0HwkXwLmIoAez/qoPwAg5UxaFUAEQ34K5wSt5+17ZgYywZ4w9fkkwGJ1ARRQi
         5bt8I35DsEsoIWxOYy3hFDZ0rwntToOqOskc9zhEzf9C00ez3YEmPjl+MLhVDUp6l5T4
         IK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781102235; x=1781707035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hztkJLAOrt3y4FASh5Bx2C0OqdOIndw7eniIOKrpzws=;
        b=TsXJQ/K6YWTXvPu3nTEadDU0LCcaXOE8k4LHqzLKLT/PFmwMOsbUdxL2zxUKDEF9oP
         oHbEm4bhV2crc/0dpTiGQS+YvYiRW1tVobAd9JaRFd0qQWsNoGAJGSkWUw8V8F2IDuO9
         LaFaypM+nSbIw2iJSokWt9ZJ778vJcpFJK4Ew8oCtcCaIxdLjtIYY57sHy9dVN+BaXKD
         G0aPo6LvsjCV2oaa0APE4JKzGr+gs4Z0YbbBiEtWfda/XB8YA8Fdv64hU/0lEBDQZf0A
         Rz/mO16Tbth1ldcrLG7hOftXhJvAEpkfglLMN+CDMU4Jg3TOHUIFZActoNWvbpH08Jqc
         fQxA==
X-Forwarded-Encrypted: i=1; AFNElJ9+kxz0of77XQws60EoT9bOAbxpxCPQ1aFOPKZ0GH8JEiIB735y8vqrPTP5LAUX4iUrUqypzleKIA==@kvack.org
X-Gm-Message-State: AOJu0YxMIXXLh0YVeCSVTwzO+GYVHIOZMGOXLowCRXZM/1ZIbl9A8I0Z
	bhPTBvXCTpL2qBOsQ2MCDl7mID2Q/bh43LRuNMRa5N6jIwa7Pjz4wf5Bi04R0oHxGQ==
X-Gm-Gg: Acq92OHwOLtUpN4QmcrHf9Uo2X3oT2G/NnMtW6YIKovQmgrgdbqL8gLroiEwkQqPDim
	mpD4oPCTZm+sPO7JBD3DX4W1BMK4SuH8iNhS7yTLmvanxQE7bgYQPL1kKxdBF3VXh1MIAagtjH+
	pUz1Kjoac64u+6PAFTeoCuuV2Mu0W0JDOIwwk8waztNJ30ecH9srqGCcDPskc7Ppq5Wq4FcAtu3
	AdqjEkWalp8m2Qa6OhRRj67U4bSXunXNqNrYs/ciXhHnunfwu2xcA0LJIhasRnIQmE3nWWSDLI2
	zxM+88iwjXzrXfX6oUXFXnHvQOnn8gbv2YahHeZzFYJ6vf1BSDmZPgnxkiL1DIITpdqtX7gzgdI
	FcMsqycQgg3gfXGV9Qf35o3/tZhU/bdfoWlCdW6ERhxlJJAIP0XMywfeomZdsNzs1SoSvNrQ3kP
	/j80+FND8nf88qm9sjA3Ea8hYYoSOrmLm0IhEqxTiumZfmMLgLXYfC19vv2KQObHJ2sL229Qw=
X-Received: by 2002:a17:902:d4ce:b0:2c0:b1b0:376e with SMTP id d9443c01a7336-2c2d936f08cmr13905ad.8.1781102234239;
        Wed, 10 Jun 2026 07:37:14 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828821c5sm23191040b3a.32.2026.06.10.07.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 07:37:13 -0700 (PDT)
Date: Wed, 10 Jun 2026 14:37:04 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
Message-ID: <ail2kLnW43fF_Sqa@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
 <aic6mdiZ0qUJpFca@google.com>
 <aihLTgs1Y49OXQaV@google.com>
 <20260610000704.GR1962447@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610000704.GR1962447@nvidia.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E646A0006
X-Stat-Signature: grzs18o4r8c1fdye41or9ezs4rt1x6zq
X-Rspam-User: 
X-HE-Tag: 1781102235-19383
X-HE-Meta: U2FsdGVkX1/MFimLkeJc/q/1oQxYlmu/pLlOcGWJOms4jT8IaAQBm2SBvCtVI+BozD1RAa9OTEDhnjCaK25ca6K+mjgQRYaALHuikCFO3Eyk/Umn5n+WL1UADfO/MDHxSokYLWwd6u2h1mvsM0fBY76ER/qivio4Rqv+UUBmm6mvY3GnMIrikhD8GG7NGNn7dcTbB0fFidsxPY7o6GyT45ix0xO9eQicEn3wch5spoJEVEG8MoW3xlpPyWdIEQ+v/fUzHYdtz8ETz+wrDE5AgynSroqmy2kimAfRIKRJ8qc1bNAibFOxn2eF0HvfuBqmdrlUCC848J48bmZhO+4JqPFKi3BskKvFgCxdPPwm+nYUHoz52+NrkIXGlZ2UhDe/lt4uHSfZEYZZ3xUnAbqj/z22GKmolt4yoiB6gHr3KOtI5u8WbaQYasoZnn5b0G7vXF7Gc0MDG7nlAKjWCb4RfpZ0Ffp9P2Q8KyDIxQMALqPNyyMAWBV6VnOIaeugZu8WfG4gF9N8XwMzBmNomLbtJjV+DdNRONsgQ1uAsxJ31vx4XO0L5R8EgqvFqkzxmHUkyg9qht2zzAB0oUzafwOvJ0tzrhRD7vd5Zj6tPMwTP6NwWYdypixQgmcj/tEW3vb0ksWVJUP4TsE4hty8zjaH7xX3jurwayW+Nrm0aTK53B8dJVpNaMxEzfl5IPA2g1IxogDgwGu6ckEeG17yOyAWTLQrhQCpw7fbxBuTUtgF46u1MXSuqQUYd7Myo4Ns7+Zzu47Sy4cw3OluozHzCnNgipUK86PqKxhxlG/ou7GfnGCbxacdUckQ6DQbGhB5ERjvWyQHcJs3C5oPq/NN3+VTF18CTQVKduzVLT5EwHhyIGHSNkiT8EyVWLsLS/tMwHkMpHjWC/qClHR0ujf1cQG1v2IrxclhIG9mOJMl1qb08F4qU9vDdBaz0E7SGa0fy+I2JyhlxqxVrIGjNxVfRNV
 Dz2eWTLn
 T9SQtoyqtWgWFzkPOLBsmODcLUdvu51EJqrS/Wba5dKWwyEKtbzaIFPLzNJZhOJUt5iLEDfEMxhw/Kncct8E0yDxSG/MbjLpZqljwoeTIBGiFLfCDV3aUQaOONUTwew7FqNeM5TuPGfrzUWOJwrGCbjd+ZQb7nQwBk2s+cctxlrF1+DdXr0/xnSB3maG+X5oT0ypsX95nIsvPvHzJgtlEM3eCJQ+hlI+XujWFis/H1tIuVTfsZx53w/XiGqBWgFBS10u5yjKlagM6E2A8SNMC9JXaRE7H2mhLJXgz370MhDijNHQGJ6T7xMYgCqK+/BL5o6ZFR81QBNZoileZom6a5711mSXjWAJ50CUrKkG0FPnGPer6wC4JxzDnTIcLwc57fWkEEY0RtLTsPVj4kWRm3k0sq1r/RoBy4A92Q8Uu1TIn9xJWv2yTLFJ7MafMQesw6wrX9OHkfQwHmEzqYOKut1KsS4WZ0NGWryaY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 09:07:04PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 09, 2026 at 05:20:14PM +0000, Pranjal Shrivastava wrote:
> 
> > Now, the attacker has an opportunity with Liveupdate, since the devices
> > are already assigned, if *somehow* it flips a bit like ACS_RR, the
> 
> If this is possible then your environment is already security broken,
> no need to involve live update.

Ack. Alright.

Thanks,
Praan

