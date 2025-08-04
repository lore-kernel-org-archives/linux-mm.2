Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BF9C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22268E0002; Mon,  4 Aug 2025 10:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFA038E0001; Mon,  4 Aug 2025 10:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0FC98E0002; Mon,  4 Aug 2025 10:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB9658E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:51:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 819181A046C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:51:12 +0000 (UTC)
X-FDA: 83739362784.23.D8B78A5
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 779E42000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:51:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CUZ99egS;
	spf=pass (imf03.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754319070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QNi2433aMOcT7VvcJO8yI0WQRWFprB/tnxl9b0uKg0=;
	b=77f/GHtvXa3dUUsbKNUn2PHdMwk7qhtBRF46QGpFk6gIxQu/LkZxp6ceD1hUogeg0+LSLI
	7FOFzEOZ3T5W9+lVe1h5A4pDMjuLEPFW2ZjmqSwy1eDW5RO11M26ErOubhCV23cy/qXTnr
	3dBCBo4SyaIsYgggOXnKZx53GTW5L84=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CUZ99egS;
	spf=pass (imf03.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754319070; a=rsa-sha256;
	cv=none;
	b=lkEGm3aKrUp4goYSMm6WWhJ+TFKpob2E7DsOjLLjm3e5tAGQodzccOfL40wqiHugolIrBY
	eEfsi2nQONchdJ2aOQ0OvfuWwKF95YX2fZPbvdaFgRFRG8FZKI4Y7deeZPP0ZWtrnivHzJ
	Ph8IeIWcL8EGPtCI+59eiJm5pNhiZCs=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so31365285e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 07:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754319069; x=1754923869; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QNi2433aMOcT7VvcJO8yI0WQRWFprB/tnxl9b0uKg0=;
        b=CUZ99egSStmhUuzAEGa3tF3J7mrvSihYcILCtY+1lWWKk9lnFQQpnT0IOBbISpquQe
         RIbEzyD1vws6ow8KL7wtsCt1GeaIlJsj5hIpg95+K3ftSwAv/NWyGI9Qr2vYQJjWyhww
         3ylbQHRf6BaAe11Zg1o68C1rR/tTcLcLEr4s2J2xRFEOZhJ0JG9iJw3eluDaCT1pPa2J
         y3tPVji52NwNq175Svgr4Z5NUz6BDMTCLYzzy2znegqL8v4rNs35fiZP6UyqLL+jQ971
         hjbTCE5MUMwlm2DgMmj+05UHpZqBn2il+RvR/phxkg8qH2jDxC76sj1mfa4uVKcH2+zi
         k17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754319069; x=1754923869;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0QNi2433aMOcT7VvcJO8yI0WQRWFprB/tnxl9b0uKg0=;
        b=Mdv3QWmGk8spTX/+JHexENjUvVVbwnKOnPw9VNvjRK8M7GMHkIgH9TwVUO5rbYgiB+
         B2WJvKkEcqZUj0LN1JTrbc1aRV7X/PTU84yQq0Coeom7SPTaR/e3VE8CnN8lTUrtvZoh
         ZU4g05e3HJPaIhxF7R5vYtdNWLW71USC8qTphdSng2Y7LPbcUEsAD5nqSNMvub4EE3Ro
         8xjFmjQCPhORKJBzF2yOMVSQBTxGfBwSiTnQmzBKc0a9SaFtuEOrx+wMIPG1XRWo/BW8
         IDLWyMaG8ZyDNxGqllXEnyasSM2TrROTUwzZKuwo0PQ3WFgzNNblhr45zilvvI1It6D8
         JBMg==
X-Forwarded-Encrypted: i=1; AJvYcCXvJjvKvzee6OEswdrUsk6hGMAUW9HsUQ0GtvSS2rTO6V6krv4EMXoRkW0AlJxRrXOK3RWn3rs/Vg==@kvack.org
X-Gm-Message-State: AOJu0Yxe4ePukqxJNAGJ/HZkJahdxh6SKi60JN2veyGYLfWtQ8DcQCq1
	cJY70msdzW5EgsLfWfLp7upmSaBRehBNhZHdf7GtfewpDusd7YjPYMEW
X-Gm-Gg: ASbGnct8daRnko3xdh+gIsWQysw0lmRQvHQ2T8u4oUqxgmV46505KAhhsIMRUV5Kuah
	8smD3oHKwH9IA5qv4nTv04v94PqcSarM0RviaaCu+h6gpoAA7VUT+LgxsgcnoWOuMCs6NNfPPf6
	TFgviw4jrQg7Vfw3R1YedD44Q9FD8uu6WAqXvfot8w35yefqpt1CaEaxMGuIlVrAftU8XPIEvgM
	Q8WcTvcW6WMR6RcRBF0CI1tA9+/ZBdpiW2O/3hT+/86ygRFzSETx13ngIKXKVP2joOsqdxCER2f
	UxnKviLCbAsAnIlcBn3EQJYuCfbTIKnj9iBm9L+ztwj4MV3HZnt+kuQwqVgyXB/ie1Rn52GbXMn
	ThPp3kWXZ4LpeV5/0JWg+UK02Ghcyj7ofCWWdsA==
X-Google-Smtp-Source: AGHT+IEk/XsbxMajLX0zrOWwGT5yoALOK+d2YnoUE0SWEpt7Bdw+f5idlnSsn8XeUpvU2PaNJyVvng==
X-Received: by 2002:a05:600c:3113:b0:43b:ca39:6c75 with SMTP id 5b1f17b1804b1-458b6b32b36mr78981895e9.16.1754319068717;
        Mon, 04 Aug 2025 07:51:08 -0700 (PDT)
Received: from smtpclient.apple ([132.68.46.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459db13fc9fsm39629925e9.7.2025.08.04.07.51.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Aug 2025 07:51:08 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <2a1b7ebc-f27c-444e-be89-df14ac1dc97d@lucifer.local>
Date: Mon, 4 Aug 2025 17:50:56 +0300
Cc: Li Qiang <liqiang01@kylinos.cn>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasarya <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0F715281-1754-4D81-A71D-4AC20BC13095@gmail.com>
References: <20250804123923.296230-1-liqiang01@kylinos.cn>
 <ab22e314-63d1-46cf-a54c-b2af8db4d97a@lucifer.local>
 <2a1b7ebc-f27c-444e-be89-df14ac1dc97d@lucifer.local>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Stat-Signature: krgcwkjohrk9pt4qqpai9otfx7nchxma
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 779E42000C
X-Rspam-User: 
X-HE-Tag: 1754319070-317456
X-HE-Meta: U2FsdGVkX19dXWL8Ewwyivy7SmOLO0kaLgJeXIVMON6HHSBtOLlEQnEylfEsR9/B1j37mtFc77pXL709xKBzRD9fGKBlHWw5/BIKW1XsiV+WWAbajzrTaV7D3dK1VCNAXsaoRtjksQf/C5nwobIbITD/wHa3RhmPmHmSn4/w8y67laVUSmakOU4keLMv9w4f+t2U3UXjjZjUXgRgphnpDwVNDTz14+mrqb4AofzCNVfJuhzlxtKKDbUgiY9mHSRoPiUWbvr9xKwE5J+EIQ8vMbOWeKTzKdk2O/i2/aUFVj+EoSnc1t/ePv3c8qP69P8Xr6vijOJ2SjOoScI/9qhrd/I/8gbt/7noYWSWjDKnWWpEq/w2+uJKXiigfy0ro0rn6/vo8ULHe6rSqyxt3mWv72mT647b1Gt9PmVfADJM/EidO5lx9FTnsoPYOsU/rPO/SrnmwKySMxQ9IhktvXAbE3f1ovoYRwZSyC60As+sGCsZAMX9MQkwpQy2AZrlXh6PallsjiiM5V/9eyxSdQHU7PdI1E5EuGNOOJx7W2xA+HY2w2E44K9dMPkbMjIbVroo3hhjVk/4Jr/5KSgbrPcXcdEVPX3eG4YPWG60WNYYzzrLVPsYi6h5RUUCF7IkVHLJf4Yzxl9vEkCqh0UR9SUFuBt9YqNFCw/7Q2cVCjW9wox15x85tpw63Vcr0S0k4CgGxGFnMcjHMmxJu5nT+1NvCOWkAgCitAGg048mHv/cYmAx/BSDX+K/UFsPjnnzbJ5qo6vv4jGoa6/nh4FXlb1GJH4idSFres3E+TZsCM8qkdGFyl5+eZeSbvnU7BZaC1oJEwYoxptX9dXPPQTHP2/hGsQnSr9DAn51mfowTQ10L9dW4vlu3D1Lq/11/uqSbWj8jldn8C3bRGTKepUSoq+SAP51wve3KnoszqJ1+Xd36tzFDpyBUWALVmFFaws4NKu8gOXlFuLxvfN8hYlCHxp
 c+3VNsR8
 yECqzV5B8N8cLt/LpBOAs1QlUvBiBa0jyM+L2iqTRnWq2eTOystgyWbYfekb+JZovztzk7cssQ1r+qoUaroQWw9XhTkYvQrIujf9w8UG3MDj7ZGIVBVhJV67W+nWokhpMRnamjk4wv5uhEyu+CkoaxK/SQ2lSQRSzUKnoKUYcVkIb04io/XXES0M7T9fBjn+L/RKLn0xyP6V1In3XhXIm9+HCrhbUjr3nlOSgI6NVMfLTz0UZdADfKDk1dw06WCOu6OAT4BTx+fNSnJ749neM5pv6aMenZ+MHhdoAnsbZMSoi3I+8S1n9HjQ8H5eIFIrEAnqSmTSAsO0fowEmtZOkXetJMFUDBGedB6DBtjESjvBgpx/PN4SU/xQ2Vrj+z12ULy7SKF9XoL8QcJQ4Rewj/x7n9lCBJbbyafpj5BBC3g93+sgzYp70JBicSS7xhcR7LYqY04reO5oPIPLrcaRTgrkS3sfdMQBFuzqQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 4 Aug 2025, at 16:59, Lorenzo Stoakes <lorenzo.stoakes@oracle.com> =
wrote:
>=20
> OK,
>=20
> So I hacked -fopt-info-inline-all into the mm/ Makefile in a rather =
quick and
> dirty way and it seems some stuff gets inlined locally, but we're =
mostly hitting
> the '--param max-inline-insns-single limit reached' limit here.

Yes, it does require further investigation. My point is that sprinkling
__always_inline is a slippery slope. You start with putting =
__always_inline on
zap_present_folio_ptes (as currently done), and then the caller becomes =
expensive.

Now you noticed that the caller to zap_present_folio_ptes is not getting =
inlined,
which is not surprising because it got the cost of the always-inlined =
callee,
so you put __always_inline there, and so on.


