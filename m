Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9597E107526C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA966B0413; Thu, 19 Mar 2026 03:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2336B0414; Thu, 19 Mar 2026 03:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8726B0415; Thu, 19 Mar 2026 03:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59D1D6B0413
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:21:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 192E51B7E55
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:21:23 +0000 (UTC)
X-FDA: 84561966846.13.B6C5218
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 363C3100007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:21:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Eempxc/N";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773904881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mT5CVxEEsQlA7iRjeSIzOh9lr8aiAprp04Qac2/CxY=;
	b=v42iJ6XUaFccHIiAqsyLTBhvW1E4H4b20G74OYz0yz0af0SVmIXbR0GH6vByGNwr9pT8Br
	VcN43PabKDVn4eGfCjRuBzzTNppJokm0IGgNuittt1PyunnZiwxWB4g5Sg1i6b12LIrS2t
	xZ61CzeqaDGrBq25RkeszvCdn7aNpIs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Eempxc/N";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773904881; a=rsa-sha256;
	cv=none;
	b=5Grj3QVJxe7vWBOxuF2OyNGXAqrKpd4rntzuQFQsmBCVan24wMC6sJIz3RVfejM4IyevFC
	IG13fOcKXTdziSh9Sgjej+yiQR9O9dpW64U4oSFU1ibDAVJdQCWT437v9QLVzgi+dr7Vlm
	DMOWQn261HyJzDc8dZp/VDsJ/qyszhA=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c6e2355739dso266209a12.2
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773904880; x=1774509680; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mT5CVxEEsQlA7iRjeSIzOh9lr8aiAprp04Qac2/CxY=;
        b=Eempxc/NYGSicZWg3RRWGWT9OnqVvBOhzO2GjN80yfoMe26QKsCTKbCSuAGHQdGsIf
         4vKAgMCgpZWfKonmAXBNcJTrMWs7wSKIBMRL8Ijgjk/EAju0HZgHIDLTssKqJ4UVUdDc
         v2QU7XQUcsRQoxpcQsAn8RysXNyp2orqEsGMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773904880; x=1774509680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5mT5CVxEEsQlA7iRjeSIzOh9lr8aiAprp04Qac2/CxY=;
        b=OPF8Deow2e+hbZpPc2V6CtybQbsTGvTZEfe+0g6QY4Qvn6V9W+qsUXF8XHIjWul4Nv
         B/nrLNPlJlfWxY0a/bDpVlWTMBTuG2bpg9pI70sjv5QzYECvouVz/FhgXMO/TXQl0L3l
         e3WQcy5xGVAy7ivMjObDDCzwmj7OIMVXzXjuC9SIRF9rxFLp6J+4WQ0zM01DVpcaMpZ2
         PToRRS+KZ8mlT6NoctzB5564zY3knuKGhuZXZ80jNpAhHjEBKiP3+ZkQEp5uHDy85MCC
         a/vOpJFcaewuq41pECGMbYjtY264zeH19l66e819nUXq2KWMNoRzZ/uWDXjGRYhz6mBJ
         uJRg==
X-Forwarded-Encrypted: i=1; AJvYcCWgDkIn6l0Z5GZiTm31G2xrZij+sM73962W6FvQIzUk4mZNLOctim5iac9k9ZTd5d8PgoovyWv51w==@kvack.org
X-Gm-Message-State: AOJu0YxciRNlUKTy3G4d/Rp+XqcRkvilHzyP360jmAzPSuGsDBL6iYtp
	dbkfk/IXtgfo1smt7l8C7Aer35BPNpwyCjQ9ELDS1b6LBGPBQVYVpkPG6DVKwk2RsQ==
X-Gm-Gg: ATEYQzxdTQejSeHLA4smYxeF1/Y3jqpVv/HJTCL0qf6ZGboWRD4egT9FMhhrBlpFRVh
	fTAMZABE1YxwTAPR42YPj05G0J7Lx/cqJpD0m8nOexA+F955McW0D2h5wNL6mH9aQwNhCQ6F/ih
	Y6/XfQYcIB4bgTpfyrYD5jlopmLefNrACvwGAfIWiSDse7Am6caxUAGerS64jrUZsuZLRMaF9w4
	IEMaKSlj0TltXZolOY6eE0yDZs4ACLVB7rKbp4voiZX+aiU6whW+dyPcThPVsb9dBEWYHaMt+Bm
	woRo2EMU2dnYLdCL0YsznSNIeAb0B39dHJAaFXP/0L4G5GLRH173axTkhZBYnny51RrkTsmTH2P
	Xts6kr9Axhv7MooHydu9yJh2xss3RfmG9c6iwTN/ByLvnrBejRBIBdkngZlO+tu97cfN8PBgod6
	4/d5TIbnySN+rF5qZ8RbftkMWpBZcZOrQuTLcWXDiF87m5ZGHMF/wqTw5LGzF+hXc=
X-Received: by 2002:a17:903:1b4b:b0:2b0:5c0c:b9af with SMTP id d9443c01a7336-2b06e424b48mr63922315ad.53.1773904879945;
        Thu, 19 Mar 2026 00:21:19 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:13e1:7517:52f3:cfc8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e448fa4sm48352965ad.32.2026.03.19.00.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 00:21:19 -0700 (PDT)
Date: Thu, 19 Mar 2026 16:21:16 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] zram: do not slot_free() written-back slots
Message-ID: <abuj00rFtWVMThVA@google.com>
References: <20260319034912.1894770-1-senozhatsky@chromium.org>
 <abt1dsjsT9826Ewy@google.com>
 <CALC_0q_2meJ7T8gvij5oR=idy9hn5rMC_RQhCbePJFVBOOd0Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALC_0q_2meJ7T8gvij5oR=idy9hn5rMC_RQhCbePJFVBOOd0Tw@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 363C3100007
X-Stat-Signature: wn51zoaoxiqwufiq9qp1zgdzhr4rb1ob
X-Rspam-User: 
X-HE-Tag: 1773904880-761079
X-HE-Meta: U2FsdGVkX1+aRYJ/wcHAAS1wUn9nywq3B4p4V0av5TGm0mir7zfE51hA2+NWtH8kWHCGwzC/c9KT2iJf/LevfW4uN56IPwvl750Bl6/rmxK8b2w+3PKMkMkv8HS8BYD9M2J65dfJoOmFcDbkG6W0fXiU/vaaSYVzGcGwQ/mOAx4BQs0mO0ppeRwu8dz/064ErfhEFnuPpo1pyF7KEl8LtBFMp7jtoazlSOL06Ri7z4jJkdtzL3p6VvY3GM8vlLSwJcMbVfrrCyEMUq3MQA/pOCHIuRbMs9YXRiRkDWhOP0lbvDRuUT4XFCvoMxK9HarqNrTxEK1fom4VCRPNkGlkd8m1pRJk/pkOJm8sGEwQ1ZCNUigdk0b3S0Zsg/t7OrufigkQG9zm96ThYgajQ+RS5CMqa8t/LFnmSyzRWVrqZ/UeKJuNuq7bUC6AXrpQziJcpz+Ls8eadFE2AwgJt3COE5kGZzUdB+ABtOJo7eXrUF6T8+JjtXMi/jGhZzdjCVOpp5jcdWXFRGNC/Jw4azQ2wHp/abC2IDBm7Xb9QeKgi1O9vkcBR4zI6MVg4c+Hqs7sAb4lcZtsDl8PhueWphTw4lUlyjh0k62ZNDCUhOjjQwFVX+JFblf7QX3HXKQ30O1iCd5l/TUnGT8IOeIOeTH1QKcb2HwIv89dyLKs/B580zkBr6X+DxOrs8cZHv3nBnbGFY96gfi3WEFP3//sX6gY5EwGgw5L8n/XbIt3yQQdpAs+Dk1b9VfXhWPgmdnSX9excmjxbvKHdLH+NhqY4wMi0dhIbkilacbnHzn/97D+fV3ecyVH21cTfrnQd6tKB3ItLgeGmZiIl4WRyDNGz0AkMEvy1tAhww/Cv1q6TrtFbjb07ODwaBqKR7jNfBI4BNG0jpBTWmbXCjbnHJVe9IC1S746/dobJ+5/1/I9WVVvomLB8GAt7mb+PmhhmB3Z6ydbE+cWaKB/35ArPyjGL/Y
 xc5SusnM
 Dt7saqpYM6yX4kX//4f4Zc6/a/9nhF6OV+LkQJclqapoIzAaSJwYTs1qzaLNSAljEaLsfPiN+ifasOiMofenA8WnBC6sN2iwGOHvIGix0XxAtgi07C6dd9GYCED0j65VxcwemU1q+3Fpo6ESRI7kMeBH9r2xH7jPMrrAlOGS+BMJ9yuRyCwCrb279xfWxGnkn8N/vD5CZcwEi6qHqG2IPZH8M8h7xl5FipGPORd8A1WdyPq4Vnruy6IdW/Wv5FQOrdajgtwZguz5jpqBl+jim/Flcv19J+VrpS1L7kubFx39pT3/KBxy/6V4paKi7tjgGnL5F0ZO426G0ae14taEWbg6ek4YfXfcJoQyOL519sUdbQLXhFWA/l6qzCJ1dkeNRcvD3cdEyhR0Te+gcOEhzajv0JX3hyVq5uxudIIPZzxH1R01ahM65kWcaj0aPqXTMYZn5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/19 14:47), Richard Chang wrote:
> 
> I think we also need clear_slot_flag(zram, index, ZRAM_PP_SLOT)

release_pp_slot() does that for us.

