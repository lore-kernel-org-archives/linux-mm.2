Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B9D2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352766B00A3; Wed,  1 Jul 2026 02:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302C86B00A6; Wed,  1 Jul 2026 02:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240876B00A5; Wed,  1 Jul 2026 02:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0145D6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:58:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 746A91666D0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:58:40 +0000 (UTC)
X-FDA: 84939304800.17.37C2FAF
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 86EF6140002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:58:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RuXMkJvM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of hare@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=hare@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782889118;
	b=pDN6bvBdBfRpsqKKW6b/BD2l3PcEMJatCzTZaNcc0y+Jxe6ztiNeetK64nkCxVKwq63L+l
	5AwnLGcHQw1tLTBUuKYs0u87gNoU149Srkrixp5slQNOMJREwX8XrOlvoDWJZOS8obL7Wj
	PrxPZi8fNB4RiIR3Pt6TWPhIRwLhIUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782889118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6Htvg5E3KMoFbz7ZumeUAsKal7KTQSoqOUgZpdirn4=;
	b=XfaLMxd3H7uQakHhztlQxdVXAB9G+QSY18XqsqgFGEF44AyglmMuRxp7UZEVHUWOieEdSI
	EXreYRSnP5fRYt+MQQBR9CnWf+9r0gVW4E86L/LXcKkY/iEpj9PmPPxSf0OSaz2XMKMD6X
	H8+zUFbDe6Ys10ddN8sSPpAyAvhuCgI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RuXMkJvM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of hare@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=hare@suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4629051c9d1so186335f8f.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782889117; x=1783493917; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E6Htvg5E3KMoFbz7ZumeUAsKal7KTQSoqOUgZpdirn4=;
        b=RuXMkJvMQP+JXenMJHd5k+ALoyX1hSUL2V3p49uRQEQHRrM5ypadU4G5LmHFkQqZ6O
         R/xJOBR6xv6WgD5oSPM1539DcM31xwaMHxnk9J4hLfQIiUHLBa/ZuwG9WT+t/qLBHzID
         zwEifPKURY0n2wh9J66JU4PJoks1v/EFWTglXnL9Qpw+o9zJFJIuwNUKBwFMFUJqXpV/
         mgV4GiwhnHNmcq0/tQcimEHQIz0ltvQyOy+UGqF3XGdqK5uK4gHPpMbAO4wWJmFmPpDt
         z/y0jfsOT8baXhTA2Bua83ojEvtN8JbLH0hR/WrwFw6F186Q7zmLmgFR0J/VxfcoDC7x
         x9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782889117; x=1783493917;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6Htvg5E3KMoFbz7ZumeUAsKal7KTQSoqOUgZpdirn4=;
        b=HXZ26Z8CU9DEDSOic8G35JxB5F0YePZc48vzGu5LKbn+FDxkSe0waYfeS9EzWfmYKL
         vAx0qCcIq9GUu5KhSt/NfAF1usE8jmWRwpcnsQ1W0VEP5lOv1tJxnaz41vYrYlkiwbZj
         R4ovvhw/AwOi/FboYrSUx+6+8xptKroWNPZKceD1KIF37AEN2UoPA4f3dLkZQVoAgPYz
         fx1yLqTlDcKbzZQ8PK391sVV2p5z45NvZHohFRUCCRORlhJvioB4kV0k/f6JUg+p5jqL
         yNYx/clqplyZoUlApPX4zQGLLnLin+Y1e+qKKtGi/awGE43prqYyHVBH90PTVSu+pA4N
         J56w==
X-Forwarded-Encrypted: i=1; AHgh+Rov92DSCzZMKEstSiRksrtvMy4bqzaod78PBd76JJVYKXyMk1SPK/xX8Ix3yS9RnI+nmK31atKrLw==@kvack.org
X-Gm-Message-State: AOJu0Yxjfk27bkcMjpv3ONBuIGsohKGtCcn3zRDjVqQm2g6rR/PcLWil
	eCiAgBNbp753J9XqRpKpELb2VPv0aAZijsXNEBbc2Blds4WGhWEEbvxT6Xawy2f8avA=
X-Gm-Gg: AfdE7clV4bbNYuBEFbg8j1VaCvKMHiixYRf3Whg4aIxPgosp9jzbXwgsFDc4brCnE8E
	d3AiigpFZo2R9zq1sX3YAcu/RwnRK7Fqn3TXg59cETSiG/ofQdZqpCGEwHMIqaDW65lOySdNt7w
	28cGu4G29fI0SJBsqp3ST7zbhE5Fem0MFMpRwlim5e3iOKSXzJDfTYbGFGblO8m5ll0WDhU7ee2
	9Qk7ipUg2QN9eX84dTnhiULmi4lr4Va/Qpt9V0KMvn06R3+fXmT9QU/2URQZmyWAFKft7ymFL/P
	oUTxEw97hwQDIGHxMXVX/aJddZGH/FVohEdxCHMweCspj2DO99rdsWAFQAHBK9CMwVxEPbedoQG
	P9JIO90tZWY6byt9qlEUVeEqIBsEHMwcNl35X1WXbnxObA8EYG1ZgTDWwRThFvhCTYguwlbh49k
	y92eTtXCAYE0xma1sN7qLY4rYrJcy/tA6PlrFNqhZRN9/DTLI=
X-Received: by 2002:a05:6000:2612:b0:43f:e2b7:7160 with SMTP id ffacd0b85a97d-477574b0599mr505149f8f.4.1782889117243;
        Tue, 30 Jun 2026 23:58:37 -0700 (PDT)
Received: from ?IPV6:2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1? ([2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-476792758aasm7184096f8f.11.2026.06.30.23.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 23:58:36 -0700 (PDT)
Message-ID: <a56251e3-0b1c-4844-8b9e-033f77216c63@suse.com>
Date: Wed, 1 Jul 2026 08:58:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: proc: use kmalloc() in proc writers
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86EF6140002
X-Stat-Signature: tne94ozadeu1g5zh71ttkgy1z99piuw8
X-HE-Tag: 1782889118-360168
X-HE-Meta: U2FsdGVkX194D/6i5BRi9xbf2QSGwQ5D8Q0DXQzvNWQwHlz5dkDe6FOtvejmiPUL/njyjmBZxwVct8CajP56RzA2touGzNB7C1mplFZzLugIptOLdRkA8U7ZPXMsVmA5R4vPvY93gclxd0Y7zsiR3IwkSXkyLsjpeVMOWvAtLeCQWSQWs3xNx+jvn7getgB3mPHQwNDHPoSCGjG7Nz/IQqQnlQ8SPDNSVcmJZK8NKWTGsRHI0ou+YO2uGq++0//jgctBB6x1b0AhkeqCYUtmeCRkBzYVYgZXuIL3PKet92meLHKFheTDSnzzmFZUxWw48qHkNxy6QUOR5xv7wD6fRCfdjzLSjXIaaOFJKZvWTLL8foSlY/pmajW0nqdp43+o4t1ONxZ6paixBdanjgp8lqkEt2w+3PbcN5xESZ58eQ0bP+q9EO0NVG/m2PnwGCEMonpUOBzs0bMtzMRa56raFp6Te3Tz8tTUmKfeNGdK5vvO63AW79P+DATGuSDHmtYvFtLSbYBXhL0W6eTTdLooZuLxLoWgUBd1WiCpT1U6HeS5vXK+Y649TCCkGqs1AeuVMBKnwSTsu1PAABQL49F5rF8AzIW2/dXp5KDz0nLt1Lz6sUo/iREDj2ip1l2f4XU9AEXsNX60rhjMO050ARDuS9Rep8olsMWKDmAG+aPcf7NeXzP4LT6OTVOZnK9J3YAy5qXCkMqy/FGTCP2cpFPvu75cijwQ/4RShealrJjUujF/aFlfdS6LLS3P5UZnilElWiZy94uLdgHgh0WqnllHLOSQuz0hKzAdW+mzp8efORObXU+jVgWpxAEjJos07ik0ttx/b/9lO7o8HYobjyXtaeX1WSewuWX2acXMLYK9mhVx/pvSRUs7v0v9Znwh+bJTw8Vl2a0VBbH/bA+iy9enjQREoUl4XyULUzeksaOpyMonQo2vEFQybszXvhSdcIWkEqJGJV2DU+HVg9HgD8E
 peNI88Ro
 icOHR0De9KBt1Bk8r7ApHHjBCa1RbU5g5bGA/F3+bCQhiMMi3S+HOcxx8LUIdEeVGNgEnOeipy9VdiZjjf1SZYAyuydmmdO7/vWzv4eswNafnD7uszsakJlVlGUmuQdmmsHKhqdSCKgF3uJ2K1E3/uairHqSPW27AkOePNjmB9Z52aHwdPwSf/LDIAy2EaYrg2ZFFB/dQrJqr6qM7KLSrADMTmYVVySsxo6nsmxrHViA+ser+vZ9DcNKvm+7MSh7MJ0empnccfPtUfQLsgYNLDcBOzyTXgh5++TbDUoXH6zOOgql3LIMfRfdu6fOiBzfTibsU0K3wTGQ8Unau/4ts4g4z0nF/r2p3MHrm6ItsXoqxYh3+H2wrH3ylyxxX6guu3PSzAkHEJn3wLGaqXkp9/PJxOEcSQwDfVRQvKCvR/T6CnIrcH4RZqhFZO9ZIWrJueJ9T/UP4TB2Yv+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> proc_scsi_host_write(), proc_scsi_write() and proc_scsi_devinfo_write()
> allocate temporary buffers for /proc writes using __get_free_page().
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/scsi/scsi_devinfo.c | 4 ++--
>   drivers/scsi/scsi_proc.c    | 9 +++++----
>   2 files changed, 7 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

