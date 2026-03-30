Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B04FF494B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A37E6B0092; Mon, 30 Mar 2026 03:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854086B0095; Mon, 30 Mar 2026 03:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C8D6B0096; Mon, 30 Mar 2026 03:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4256B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:17:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7B47E06EB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:17:41 +0000 (UTC)
X-FDA: 84601874322.18.3A27AD9
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C29640005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:17:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DCrpbJIC;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774855060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGWPqeK9KiWv8GW7kijJn4MfGQ2Rs0APPG4sisBBxLM=;
	b=J7rmVS4+uJ9I+4J878ATDOIvtyq60hcZZlAUFp0RxEnI/xJCIaV0BQ7uZULg6F5r+c+iBI
	ncM71k6PF3I9AqOj2ZQ/TyleAJaqqgDp45woBhE8bZAVX/Uh2I+K+5tC312O+1LYuvRDLl
	gV4MtLB6Hwnq/m80H7xLDkCR4L1Funw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DCrpbJIC;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774855060; a=rsa-sha256;
	cv=none;
	b=eUpEPcf+aHrJJKijYZ5b7Rk06n2cRKKO7GBIaQO7JBJrxOwoFIH+h4MbOKz5n8pjzEHqaz
	IpmA7eEkHZeebI8vcxM95sgg7BKmxngcaf5VcVhQR5mCnJXBob+Ok89bXe9xdMM9Vaeuet
	KxcvcgAjt1RkEKlv8PqjqgzdiRAwSUY=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35691a231a7so2430156a91.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774855059; x=1775459859; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kGWPqeK9KiWv8GW7kijJn4MfGQ2Rs0APPG4sisBBxLM=;
        b=DCrpbJICkuzy3+kuljjaA3DSeuL24qAZMmLT3oMjo0hJSjlT+mSAQ0pxM1mR46leuK
         PDUQ62Ob6KWRMaLvQ5m6zAiYiv7OWdY02z58oMp8XHJTWUMpTZzwo1neCshJwXTWDaxd
         Svy1PvmeC6+iRok95fGpT3gMIRWTKgcN8BEfGNr18dNUJx/TvUIlR7Ff+BlUXrROm7Gg
         /HhRMKOrdfo/I5IBiax+OQbibnznpsaMDH8HGIeplK2G/RSezNif/fMhzcci80CCnFLT
         j+vvp3bJHCgrIGQtOF5Y0xM9nwV2eJWYLb22uXXwFfACErkCB/ewmdW6bf99ZlGZsHi/
         f2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774855059; x=1775459859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kGWPqeK9KiWv8GW7kijJn4MfGQ2Rs0APPG4sisBBxLM=;
        b=iatp5F70P0swS//7I2ad0cMN/QUpAmQXImcuIMlmyS9Kp/KSzv6CW8XIYCxh+NbaKA
         M4+WBxcVZ1ioabz5BthYcu31ym5sLFROm9ZwXa2ZpLmAru7D2V0XNMI4iQnOo/ozjq+W
         Q7oohVxr6pH/ULkGPsUovBOjcjQSXZ+RvH1dve7XfGMgHESXBBSYfOQFGWbWLJpUDHOW
         Sqxjy+lV+6ypjESg+lzFWBWzjvEGOAKNQj0LKUrQiB0bJTislbQ50T713eff/q351hp8
         yGHxj6kckR8hrEbIqA/e0mu7u/7fN9pnFxYByfTM6Gf+A5xGEBYJQ2rrcZx/OrrBLKlB
         wQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMS+xNIufNtvzkiSBQliTX6kMpoR98eQ+luKfD+wm+5IDq/dsvmup8W5FdAab2PN7PQtWrm16uxg==@kvack.org
X-Gm-Message-State: AOJu0Yy9hfWukPgup07WaqMm3K04CrqHfcuwFXJ/8CCREJP2IpyYaSmV
	DXIVUDHLSEA7sIuf7GN6oQS0OJxGD5I3/cHXsd9akdlVOQZiPAbFJVX+
X-Gm-Gg: ATEYQzznc+hMpV7xGyv0bM4cxADuu2mujuzxXzvx9dsHJrjLxdz+9JbA1ZBrJN6U05p
	Uqa/9NFu7WmpvKb3qCWD6x45wf4/OVwk6Z8aloTmmr2R6B/9uGM00NC6I2XPAlOs3oD/D8raNz5
	1fBvu6zNGprmUfXZGD92NtgWUTjBZJNAZKt4orXYi07GJm7tLeMqBXZ8//i3nNW51aqGH/yem0d
	FIpVaMe867y6kGt2/CcZhCOoezjN7TAcLZptTgZ8pge7Mx33vk1TWA+hNb6nTE6wsouVqLfaPaR
	oK1BVti9rqg0RggfWwuevmGx5oufzj2GraQfIlrMNSgbupMHh9No+l8mrR0rsizkGIA+znsKQFp
	zIHjC08eV34Mj4ywOp3VfV5JW7n9UxwJLpqdR0AvR3RmHcZ7USTS2Bzrej1DHMFOCvmMEPeFTjk
	qHAVl9n1Io8NLRHtjdmonL+HbIwY8BpWXRT3iis7AdSQv6di5YUfQ=
X-Received: by 2002:a17:90b:4b0f:b0:35c:b02:b5c1 with SMTP id 98e67ed59e1d1-35c2ff1be37mr10325599a91.2.1774855058782;
        Mon, 30 Mar 2026 00:17:38 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c2d8d47c6sm4624349a91.1.2026.03.30.00.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 00:17:38 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Mon, 30 Mar 2026 15:17:36 +0800
Message-ID: <20260330071736.17143-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330060851.4659-1-aethernet65535@gmail.com>
References: <20260330060851.4659-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C29640005
X-Stat-Signature: 3weqyc1k4o95t7y6m7exhpk3zi4mp7r7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774855059-116218
X-HE-Meta: U2FsdGVkX1+9nYdWEIK9TwfQ3ZXygDmNo+LaaO/nk7sRH3pebs7qMP/XLgoV5MkFyyS2GnHjXrh5bYjf+5wYkhGhabrBivShRqbEIrX0lA6EA7DALoW/RIq0/NlvbmM5PLYxdXoMBC3oJNgczj0yMUhyvLE/yWzzWMBWQJBLzkK83wOJEk30bEj7Dfpjd7N0HU4s98/VIeabtbolO+Sej0t5U5APSj+oAJUyTQ230H3NrNT4weFFpNcp8+RFZzS3xfrJ/l+5vfrc1AnTFlgUVdJTTE+sj+0kOnP/kFSHgcDravBkbHyNh3DhjIk5OjK4CBvUMqcDbB6yRMdxZGu9nQUPGbtTzS5OAjlRMxGQLc6jBcR9lm7LOMjImVQ2mXDpHuYfUK6F6yDag9oPuv2Fxea6WeUk2y95SLPy6gQ5fJpwHs6QR9ROtZ4vlwxgGfv7mzerohsFnX3T+T0rcc528jTjXJKRueskv22IVQwIwfB/9zo+ZwUXjAISRkHMjpDhKfDPyUFNMqwQdu6yHfCBdOX1mkLs9byOtZnc0LrCJuhSDlKp8HCL24/PfZAPWxDJVpX97GWKnv9o6vfyCY1xy+aJKsnRqxNS88yU9y6g4xrGzXVncXoDFPD9VJuDgRVKXwi1mcKY9+fKi+1q31eictNeBmMfTfTxSzvEKPrtgz2ncnKskdakAU6fIsTK8ZhObOSqIVyLP+ivj50xbKZyk1PlTMdZEtmOy7lJVbdnfIDAoBF5H5z5lpGya5h9imovXsG2GBLJGDUlWzS+7QOeAmvNiImjHbpmwjRCa0JoDPCDTt71QaT9Tc6bYVym7pJOBUPjNJOhhyWCn0wOss26wzpy0+N49JrJy/qGDnDN3KUl+W4RM2uaf6kdCeldeTbluYTdjZKLBj9TzG4dNTx/tx5X03f/AGXT8IZVRfa0MO9K0wtRihfG57UUl8w3raKruN3Ji1e3vi1+Y1WxhZO
 xIwGT6eE
 lLdppQ0Q8eRlZpJbAzBC4wTcz01tt4BV7SkyakwvJQ9ewO9Gy2Sb7EGZ4lJGuFSoQqcL0zF8SCFO/VV1JTme+4ByoTqfj1aAliToA78oocVuKd7lqrIBepNTLQZuX09dOowkOA/y///IM5cq2bTxgyudlVfLNhUHp59vBioHKhuATJHBJbfTAXoB0WGPqwYd9qeB6q2zJFe67j/XESNgVE1Om/7zO33gnSlk58oRWPxSJS3VVfrOaMbz85WZ08yH0NHEistV+JRoVXlIC6rmbYnx2AtLF6id6eXfVPKPEQcOAr046yA6z8OpBbj+NS2QSvjhihVpnuU83ekbGd2jMmHvTUTgYuuMqLq8g2Gv8FMe19XzsBrSfVKlXbDzmyAHBpCq1HU8zuPqmSv9u8Ti0Yf6U9+JJ0oyRedyR3MiKHAdrxsaQ3vDAvcNDD96KCJvhu25nkXDvneU4uURhPTbYYVeBwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 14:08:51 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> [...]
>
>     min_region_sz = max(PAGE_SIZE / input_addr_unit, 1);
>     if (!is_power_of_2(min_region_sz))
>         return -EINVAL;

Apologies, I just realized I made a silly typo in the code above.

I used PAGE_SIZE where I should have used DAMON_MIN_REGION_SZ. While
they happen to share the same value in many cases, DAMON_MIN_REGION_SZ
is the correct semantic constant for this context.

The code should be:
    min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);

Sorry for the confusion.

Best regards,
Rui Yan

