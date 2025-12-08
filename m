Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FF92D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 07:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B0A6B0005; Mon,  8 Dec 2025 02:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BA16B0007; Mon,  8 Dec 2025 02:39:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A616B0008; Mon,  8 Dec 2025 02:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D11F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:39:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BAAE35BEF5
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:39:43 +0000 (UTC)
X-FDA: 84195504246.04.FC783C9
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 154924000B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:39:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b2o03NNF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3vIA2aQgKCOcSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3vIA2aQgKCOcSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765179582; a=rsa-sha256;
	cv=none;
	b=X3DZg7d1R4I2X41Js9V4Z67jPGJvA9TVOeE6t78PyHMIkQCA60DHDtsrmue1tzDIhoeofW
	F1l8wOmmbullRDbKjtSbFZ6Y2JN/xcf0yxbrB1zAvo29fFIk+xOk0lWjfaZ/bQ3tbpodnb
	YQHwLOYVZhzvDEx5G5Q61qqoPOY/rpo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b2o03NNF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3vIA2aQgKCOcSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3vIA2aQgKCOcSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765179582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+1ssDKimEy1YWQnfRj6jC4uzuK7az5xDxnS/OPdEg0=;
	b=k3POhAvz1zy+w/5AeVj3FxMLbnV1/2jxAN5UOxkFm9galRTfn7P2gSFZMQ+cf8vLRRyvZn
	BBP5ksZ+e/WtzjXHm0B8aN3AlpAsXr1xHgH6cDQkDeaqepXC9oSns2wb90kRkgaaFJFKZ+
	bBsU+iG6kS4TXsoh6sv6ZlXeMiB8iSc=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so35609135e9.0
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 23:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765179580; x=1765784380; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v+1ssDKimEy1YWQnfRj6jC4uzuK7az5xDxnS/OPdEg0=;
        b=b2o03NNFK4FEm+ifYFv0Jjs2fuBLu8FXxybEYL9tqNCYe8rjd0e8kggK/xXqQFjl4U
         Hlh29kU4TIrhAuM6UeuHH6y0tcP+z+znUqpaqP7GkncdN/4SheWXL23Fx9gGJ3E+yXgC
         tvIKpKcl2tJrQESEsy1PpAk+EimbPcYp9fsKfjSd20DcMSUEqIuEI+SdcADSrfUkJAm2
         5swOW7sFaUeXndNpLsVjaqfaca8GrHcCsWyXrIY1S3eZF/9FinXBr2piWC8Ef0psKtW9
         fR+oUSf0tKNjni6iabUEX8ICu2tUfPR4BdW8W7xde3gNLFABXC+YVYG6cperlmftQJFC
         EINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765179580; x=1765784380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v+1ssDKimEy1YWQnfRj6jC4uzuK7az5xDxnS/OPdEg0=;
        b=Y2fqvilWAv7PNiubm5jZYujz4mroty28z4owjD9VPBV8ST5EjriPjz7+CZ+ACP5DAs
         hkMcpOJbqUyRcmtP7Y1/zGmH/HxWiOm//pqZU4Fp3nrRj7yemV+yxLynBzFK35BJZSWs
         wuKErXmGKO4sbt0lEwWvdKtrMhYY6GuiBD1GgAzbcPnFLgHZzJVlOOn7eGj8C0ZoEJt8
         6p5F3KXIpcrDJ/AzwAjxSQA90OuPXPsvnZVSpoCfz4jypVoy59NI3Ffuq1U71xr0Xdcb
         5q4f9pQtB8Wl0c3JuhXy25q2MRxqeYLauUVKBDPASaZzQznLNNNNWk59WqhKqUvSHlF1
         tzRA==
X-Gm-Message-State: AOJu0YxjhwLRUYI8z06WxB7bnPX0h3OL0GCrEX5XFNu3is/VHa4f+YTE
	+GPlPOHWhPPF2Xra/yckl8udhvwcu2CLNB/B1Yh11LobUB1ojjB5DlzWElpxmkkjKH6ptXFEpW8
	y+02t8VAPgm9AFg==
X-Google-Smtp-Source: AGHT+IHvVBiPRFe3ztaMxMTZdIQQQD0RDtpj8NlE3BbQLqpyQhxnvDTt5CPJ2CvTqc9YXyalpRNMld9mzGp21w==
X-Received: from wmfu9.prod.google.com ([2002:a05:600c:1389:b0:477:98b9:1e26])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6289:b0:477:7a95:b971 with SMTP id 5b1f17b1804b1-47939e48f61mr76546105e9.31.1765179580124;
 Sun, 07 Dec 2025 23:39:40 -0800 (PST)
Date: Mon, 08 Dec 2025 07:39:39 +0000
In-Reply-To: <96aa9bf7-1f1d-4870-90d2-84d3d6d4254c@arm.com>
Mime-Version: 1.0
References: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com> <96aa9bf7-1f1d-4870-90d2-84d3d6d4254c@arm.com>
X-Mailer: aerc 0.21.0
Message-ID: <DESNXS1K25LW.2E7ZWFWV56PZD@google.com>
Subject: Re: [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep
From: Brendan Jackman <jackmanb@google.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>, Brendan Jackman <jackmanb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 154924000B
X-Stat-Signature: uw8snfhox5gh4p56jgcpz1kbi998chkw
X-Rspam-User: 
X-HE-Tag: 1765179581-138717
X-HE-Meta: U2FsdGVkX1/Ar6MlH0qcTVfbJoX+yNDKRENVkf3DLYvZ4paSQ17M46V3q1PJqjjlj9pDMfvQQ73qjjPYYZ498cIzY5sEAY6VD2qMQwwH+syS1kT0ThBK/E+ljCCOLk0jYCBO2sj7zE8aLVrx84F3d7XbuVE+EfyPMwNT9J1t1pdHiif2WyAvCVj/XA3A0Hn5JC6lHXCYlj+wz50jqL+iN7lbSjAA4jEkKI+HKffusO+XNi/ZUKZkIZlF6sECZO+yZDyl2ID+CoeU2rmLVookMWuSKntUClswrnwS7g/eFIALZ7NxOdg7pMOUS56vhf4hVI1QByGkffA1Fn6otuHCs++RgBtEG0ZgP1L0iBSAaD3tZhDKnVt10ogqaaNGF4OdxURFbhL4AX976AVMma7PHz9AmWvxzoHPRIzVISedolYLsSp7uEZe7RGqmPmrd2g/dFRSs5xhZTkZoL1/fJzc4HGTKKBXC9dv/+GAnwcFGqj4Tt5jQ6ienT/hSEaDtLEHFwh/f1Gg8xJsHjhJLQTmzNd8Om6I+hgZ0OD6R+OfrYLND3r1Hn0dboAuljBqmPn6szuqHAhsRz/Wi9rcbpdTSTdKwFhoLZzUgjz9LAIONxqiixXwnSm9bJxOfiTWb982GImDCJ5BwY7a3n67beHdFDWS4OXY302Sj7HAbN8xU+4a03OZsni8j8KRH2erdkR7av3KF0c30QEmWdeTVMAOdPWlzIy1qRMasRoegm7Pg+/ytYzUdGPnN+hxvKBzu1NbCfsunuEfL9e3iwTk6yd6jh0IASYamr5pB4bsfIJFfFnLNE8s+tgP9bN7Rij0wv4vtgU8BKmH7QpcpGqRzqlX9JSP+4xHI2h59c+vtzHHta0C/PMly/RXchtl9/k/rNmcFGEvVxzYdB4W0AKtBtBCFrkefhhwOgyWmv20kYA0ixNlkPDZgRPxJa3y+fYFl5xE1q5ulsYvJrHulCDxHuC
 GPa+1fKb
 UEWMw6QYFx08toWPnxdVVFlgsFK/ilNrgR4f+1jgKSINMxIXWI/y/wSfWu6bL0Nq99FDaiwwA1SUiIbEl+P6E+gqSY0H+WXP2hUXrCCcVrbXMop1H8Ltco0GkwO4isLVE/wEBfXcpgU2UoYcN1Csyg1D1FgsUmmobU03hpS8ATgOlsD7l/LnZieHBRjGpVHcmFaI9mwhIPTFhqZByrREZ3rXcM9VriT3jlcbmvZzy1IXs9r2LSnjG++Rmms/wRjRYUXTFc1/C9kPRx962H5cxwsOyQE6E3QESMsKWusssolGTb3q0CAKqwNm0ZKG5iUUlD61A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anshuman, thanks a lot for taking a look.

On Mon Dec 8, 2025 at 6:41 AM UTC, Anshuman Khandual wrote:
> Please add <asm-generic/pgalloc.h> in mm/vmalloc.c - otherwise it does not
> get built as GFP_PGTABLE_KERNEL is not available. But otherwise LGTM.

Oh, but that's not correct, IIUC we shouldn't directly be including
asm-generic headers from here.

So while in principle GFP_PGTABLE_KERNEL is a sensible common
demoninator here, it doesn't actually exist at all everywhere, e.g. it
doesn't look like m68k defines it for Motorola. 

So maybe the best way here is a really vague:

/* 
 * Different archs allocate pagetables in different ways, assume
 * GFP_KERNEL as a common denominator.
 */
might_alloc(GFP_KERNEL)

... a bit yucky but I think still useful.

Any thoughts?

