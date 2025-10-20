Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE2BCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6C28E0012; Mon, 20 Oct 2025 07:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4975D8E0002; Mon, 20 Oct 2025 07:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337AE8E0012; Mon, 20 Oct 2025 07:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12C408E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:10:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A80414D1F2
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:10:32 +0000 (UTC)
X-FDA: 84018224304.15.E54E359
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1A09160008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:10:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fWpBAqe0;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760958630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1GwM38mh3nqijwky0hI3l2FSxHPE+1vxrvYPxKuFQQ=;
	b=d/Hptyl5ZqtLfaZTtZgQkREPGZ0JT2uN4P9doDbk0JD7f5+Hnj7HybOOEz7hmNvfMuZFep
	N8aJrqmT6ugZTp6eUBxeOoHSZZuQyOYu7+Q7RKcaF/vY19VfAqyANoEvzxp/keGWeoSGQz
	u0Wbe87JGKtWW5YKb11q1VnaZTJhwRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760958630; a=rsa-sha256;
	cv=none;
	b=kCuQ8HU6+CvcEnbuGdsZHDl6ARRV6KNm2k2poqHAIDNxOdH9m8OO81y3qbFFzJx+WhnyV0
	wNGfYkudEgubY2nzs3vBLBxM7yNwPiHvhSr8W14O/cat9Qp8DJF8EmByhMqsXZtVdPtBkH
	zLShwFcGF0x17rNPfkingji1W0Xn524=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fWpBAqe0;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47114a40161so46438725e9.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760958629; x=1761563429; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1GwM38mh3nqijwky0hI3l2FSxHPE+1vxrvYPxKuFQQ=;
        b=fWpBAqe01CKV1lvs/r3tkVm4xKtkrSrpDBH5QfVP5VszTrsXEiYPeevn/XqpXT0jdd
         CCPePVPlNWAa4seTw/rXmRqXe3/tlqw8GGHLnIWJVz8ciFnV3lhxKD3SL/IsVcnG75xE
         cZ0AoTqe8WKB/We92b01GURkL062sRHlkXawD2fiFRQxQcVYldBf8ZLb0A7oZQGE+eQg
         Cwr2eahaG3VS6NczRgEgHpqSWYERIglvpam0SMIpYhe2Fk6OXHUMeOuzf3chHHaQQd9w
         iXsql7RaYKmMKGUNrvBo0Ua2m7YM2OC2GMd5k0l3UYAbk3BZIK7qTt+G5OiRp7L50nXN
         29Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760958629; x=1761563429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q1GwM38mh3nqijwky0hI3l2FSxHPE+1vxrvYPxKuFQQ=;
        b=p210WQhTPPCtk6cGOixgfbANZUmuv/XLA7vqBuEci3Eyg5041wXBvb5DrTux7UE2fW
         5P/0dDscE7spTDkzjRJResTEFbuN+fspL+Sw9Z6GW4aGrxZj6xVUuwUYSWjl8wTp4Amt
         Mr62xpnUqKtclpNYtg3UzesqLPzmNgkk1j8qHqXkCEfZx5dGaM0yiQ3Bm9SmGtGCuNCw
         YZxp+YLzwOvd/hEMXqpddmPRCEwBoElJHQl38GqZ7+h+4ZUTAPqVjmZLTyHLI6LoMkFD
         XBq+5spMCeJ8dAnaT75d6cg6h0he16aYooZGWMdcrVZmxutqna2khCIHDOCUfoarLNmK
         7K2A==
X-Forwarded-Encrypted: i=1; AJvYcCXMnzuWdCLScCea8DgisMwCDXKLEZHH603j64OzPGr5jrqADeB9gFrzKQjQj7eK3F9hYbkkfO9o7A==@kvack.org
X-Gm-Message-State: AOJu0YxhcEFb0mtX1YWRciE1rNBDM5BrLSnWEZN71yel1fL3CYI1TB5G
	eTZAHjLfwamZgKEYgn6j7cZA28JVksP60scfwJClxGhBoXarMzRvxnLv
X-Gm-Gg: ASbGncvGEYs+VuU0uYnO24b/ELCN5wsbYmno0Jlp2sdftSctiMTnPvZrJW7nl9m5dqa
	DC3jRwfNmnl7X2Lwpc8vhxDhW9HWM5htcFE/hbToB/uOI+ZKfNNcSSO6iHvWKRn/H+9JOupc3wo
	tsfo0AZTzl1odkE1CE6Uj9DoVRZHvkKCHhbGA0pevUG3AHmO+AYgtkBIRdccNT3xdcRiQ6Co6IZ
	nR3ADG2+TWGuXXZ3V+BCdZAR3KgkHPXBNalt1ZMDiTCTZFmokxkaXvvEa7Y8Ap32TPyGYJGyhSg
	PZGkEna2zsh2JIxmtJVVojyhP5iWj4IX0bbi0rB9xeajBTEhlJv4TgVH/CgCmb9iUS1Eyfzgm3F
	fBI0O2tdpAC78hzIEOu6BAbFfM8WDLqskjFj22Oe2wlBLmozOJPedrRnw19K5lMuSpWA3UgDtzi
	aeW3h1RA==
X-Google-Smtp-Source: AGHT+IEmMMoOjYfBUT5RqT6xtTVyMvQoeiu0xyX3gRg3r0UUnIXnqBqTe5A7yX+Qs8G91aoDug12qQ==
X-Received: by 2002:a05:600c:8505:b0:45b:7a93:f108 with SMTP id 5b1f17b1804b1-4711786c71cmr94484055e9.3.1760958628958;
        Mon, 20 Oct 2025 04:10:28 -0700 (PDT)
Received: from fedora ([80.195.98.51])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144c831asm218234765e9.13.2025.10.20.04.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 04:10:28 -0700 (PDT)
Date: Mon, 20 Oct 2025 04:10:26 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linuxfoundation.org, khalid@kernel.org
Subject: Re: [PATCH] mm/vmalloc: Use kmalloc_array() instead of kmalloc()
Message-ID: <aPYYovFBtHYKpgg4@fedora>
References: <20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 3m7z3h9thsbqr87ga75ate3rydxdzorx
X-Rspam-User: 
X-Rspamd-Queue-Id: C1A09160008
X-HE-Tag: 1760958630-802543
X-HE-Meta: U2FsdGVkX18iip8Wox1U0mf0+2SS5LI6C+dMkVWPDJYKhN+JOgMaO/vtcOQiFfrRsqq3LrNeePJluK3sDEzGXILJc87X3kUNnLpsr6rFTzO+Bj+yJHI0j7iHzMiHTOc/6Zehy0aR1ac+Q6zMHtHnOfeFdXwgDg/9SJRdLXi9RwIDgN/vPUw4d38tljRQOBdZENz8WfK3n67HArVkBXQ6+HTQzeD0CjbZAYo9SIjQVyVsdVPPaNQ8s4xceeHLeB1iYgf5ADdftmmlz6WiYp/VZz/69Wht4n0yEYpDtbULay9o9X9NMD1Ko9aDO2zraImhRfwzoT4THGJaLA2y7T6RLCIWDFU7KQc3tvWQ4fKbNj1+uuSVA/HHfc4+XFG58cNFST3FSUgGBObbAApWh9lwcNRNeWKigXmyYqNvlkUHYQwsidlH9inJuLYzU0qeykA8NEcTVvaxjYoXe9Ngx/LXg8aSJWLthRGV+qOpMlnxPPnonkzL6qA4F0q5jjdBmaS69Agu+eBCdjaeQs6fVH+/7V1He0AnSqJPcvi/BfZPG8uNzd+DboU7x919JKIe8vYGUxkQ0Cit3ekb/vwyqUbMlhM1t2m+I2yQYNMmmAXmL2A2eeuj261POu32kaFxUYu8hbwzgUKZnZsOr7G31ns1CgcePay8BYH+0sRxbu6ypWelXv50QWSATRfcmmxb/p7cGORLB9UWy1LhsEsV888jW20vUbe8un+Hf+Os2ATAaKVjuozPZgpHE2lzR0ji2um4fegeu+vs44TxoENgjB/K/OxMrtB/pnn4CT/6931ZiEzA6BNVPXb6+2kickhbwiswDMbnPho/AbBa98UFVdDVQM4K8pgOSWl0nZaI09ryM3blpDB9wujfw8Yhce9gFv/S71bucfJmFERSUwGeOuikPsEeARhoPilRwu8oDiOFEUs3q9EagN62U9wfpAbYSQ+RHkBW9TCJfxZ60URGX9J
 RSW2Xo1a
 mzMCYyZ40w7ug98vcNXiqh2AoIddu0pE5J7zkAK/oPsTA1JXBOb4h9zpAG0QMEZ5BY4/SS9j7YvIpPh54dzBu/1c+6G2yov1OFi98UcueTRJrf2xGV3j4WGhKTRYNpZWiLtbCJBnYoHNCy0TLnEuyj285x0F2KVn6IKAJ9CCpV1eBGCfUY1emulOL4EeGL89bZBK6/qJFZFFWn6sk5evA+9QcSLMIl2RPHZrBxOxRW9DcKIivplwQWkGFK3jOgkEml1Cnt0E30zeR+mHsLsDG6ET7upcbJvIk4GTsGmqpSDdpnVQ+Vwcnh0ct+RH2wRpF783exmPgCYUXUkvHR5ih0Z0WVvvMax4FwkxdnSfv1xioiTlv7tLS+n7EJfabOCX46zy9BpRkc8kY2N/8j47wiAL+sckW8+OX4jb2bG7FpxEPytsv8kpm/kCUx4+W830yCbVB7FpGyRODgUgPNCgKuT5tOJLNZsHCFbjGJFghVLFN5fChurkAWkrlouxvAl6vJHQMSkI/2alxjks3ox1VtoBhTlVl1yBjtUWwoNRjXYHPTHcTqkcGjuyAdW2WXkSP9SHlQD3ZHTjpdWH820VK0gBs+AJFhiWN+UFc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 09:11:48PM +0100, Mehdi Ben Hadj Khelifa wrote:
> The number of NUMA nodes (nr_node_ids) is bounded, so overflow is not a
> practical concern here. However, using kmalloc_array() better reflects the
> intent to allocate an array of unsigned ints, and improves consistency with
> other NUMA-related allocations.
> 
> No functional change intended.
> 
> Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
> ---

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

