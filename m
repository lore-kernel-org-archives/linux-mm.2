Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 654F8C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402806B007B; Tue,  4 Aug 2026 19:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3696B0088; Tue,  4 Aug 2026 19:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A25C6B008A; Tue,  4 Aug 2026 19:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBB706B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:27:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79ADC140299
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:27:12 +0000 (UTC)
X-FDA: 85065175104.20.3A60272
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F08540009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:27:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tBH8DjHJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785886030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dBrKSsfQdb58GuYUwOwwQ2PFLI5sCbq4IRlizVstQc=;
	b=POuwJhtRJjpac46zKH/WmQpdtsgxfLJ4h5IkJMN/wPZecegeZdwFzq9PXfMfMl0ArerhCV
	eEulAPViggnHExrm9RVTx4N2HmawLTOyPo/YTkbhlRo9c6Uyimn2Ikq1FdWpEGBjKpoG4+
	4TyyrFhou3WmDK9Q4P5caLkvExwUVao=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tBH8DjHJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785886030;
	b=MYLhSFNpObcUaaqBfu8Gs1VNijhGIyDvclLu2/i3D2wi9lkpAKl+7R5OYzHBSPMlEWchvY
	X49lCLqmj1LjyxgowS5kKyyrEybhHKaiOeEVF+Qib7SXny2WBvDVqRm02BeyVhle15fa97
	IiNMWEGVucIpiSThjonnBHG/VrgGqQk=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so243213f8f.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 16:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785886029; cv=none;
        d=google.com; s=arc-20260327;
        b=BfobzT6QhDyOivJ9NjiNNoLFXzL3Dm6UYUSx3ekhxmsYI+1oTL1HP6tqfmD1+f2XFY
         ZT32MptO5cENU3D0RdDrUq8ojsLVsBRdkKVCZepyxUMVMR/wIov43lIaCc7bRtVb070Y
         0Cy35Zfvi+mFuqfBRxTMbaQpkADv1Uvv8fI/gLfcEu/C9pAsfCOg6ZGxcnVma31nbcn/
         CAiZiyPcSsjj/0ocYKoucCbhFgwaS/Mbty+AjgGWTfB6dEbYjr2fTW7dHl12C1nVP/hP
         deE2RCXgdFiF1JTwiVnoNxIz5n5THn7VUem4tZP9lmKwErzfpD/a7P+4cHR4LezAuG5K
         y9NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6dBrKSsfQdb58GuYUwOwwQ2PFLI5sCbq4IRlizVstQc=;
        fh=P0J6EMQXwUVAYtEBvf7DwtuO2NlMaQgDOlNOdUcx8+w=;
        b=SxPPQkpNariUREJ6d53M4CO/mozXbMllhc+Qwe7yuXe0+iPsQSB9tRc5jqVaQk8kFk
         0jO8GLBOHKC8BTXDvEg9b/TqFFA88Ql4ASc+kC24AMxOfvUyatjJ0ah84EqP5/46uLdV
         MiUfvfbeO2I9gYdlHG1KbqxCcI2nEUg9Sx/6ZCGzM9wklsXUZ6zCd5gXDZ3b34pHtKK5
         h9YNCPp8O6Ekljks/DA3NUxtGmOOJyWfWg0JwBeGU+IB5RHBXaVJ48t9sPVwkRDsaNit
         7WabA4meoBd2Og8YAmwUQq1Cm1ItNwNWaoSBvvh2cHDcIWHhgW0yG9HZvMNopfYsU/9l
         yuTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785886029; x=1786490829; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6dBrKSsfQdb58GuYUwOwwQ2PFLI5sCbq4IRlizVstQc=;
        b=tBH8DjHJRBCTLUefs60ajBxKldw0KK0mLIPe+X3IOlxKaA5zfrDPjMam7+oQEdFVTH
         AsuzYYWtM5CU7A6eUGcOeieO6SyfI6N7hzr50Gf7yJ4OSOaZHYAXgG6HaDyfaSXHTPNd
         GVNmCzkSQCi2VIrjSQKwP0ZYoZQTubVBw+SvghNQkey5l1ZLfqhji1VkprqGZeXntHnX
         wSUZsmzPjNZEI5CSFq+ookG2keVSumpNOAem+AtEAtPetNewsol10Tj2Q319Zzdiv3I8
         /nju868TzhNC20Rhm6XoK8M3+QkdhhHbryuUidbP55AWC3xJqRF+S6JcqDS1k1Kv9faO
         qo6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785886029; x=1786490829;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6dBrKSsfQdb58GuYUwOwwQ2PFLI5sCbq4IRlizVstQc=;
        b=c843Va5/Nxz/44IbFdDbZFJok/b2EoXOey3JD2JP1gMG+hvBSPsmVqmdhQG1X7bVYG
         fBDijL9/7w3IAyUCeOayAQ99+vqPP68Sk1oJZpsVlB0qSNi0ZBZ5CYibA3Dc/3R16RRf
         DuhOLMbRKrIOVR5cr/oy4uJ1mDVLk9fQebMQrV1/21CZIFX0/BdZO8wo8VeIZP43Y4Ts
         izd6IYvM9bo8HXfbybExjibkhUoHki1cvxOEGi3HUvMoMmFesd8QMv/v+SyWBxhjB6aw
         uxX4NQvsa5EvCgDnR3f1ufT4l7LNY/sRkhpa09I1GvDBdRA+FkP2uX+JsrRphGAsCRtF
         wbsA==
X-Forwarded-Encrypted: i=1; AHgh+RpUHCMADD6UOxWdAmEwe9gzeQjWBr9SWuEFtWP3sAilYO0WxzZMpCbcmDcsvIAjGcVD0ZpsfYL5XA==@kvack.org
X-Gm-Message-State: AOJu0Yyp4jPH8w8d+o60vbFWr/AmuewjpNMdD0qi+AIL49FhOfcAaVkH
	EkgGKRZfoBmAHJl/rQw54TfYFCEZjoreD5FmZqXlrnFfHOUu1rBjpprcL9WOFP2xSadXTQtLg27
	3uthkhSFwZHRqIQDaOQggdM0aQlZfrDg=
X-Gm-Gg: AR+sD13BUxx7q/sk4U6U4qckBL3cpTH0I4nOqRsqiKNeRDctX4uD7vU/aHEiBvpq5/v
	y+s1o9OKoAqvtkz+NDGr6KU7TXDQigLZ8PgE1XNu+tAbUxLXdWU8FRuW73LDUKhpWxUlej+0Zx0
	/VaPmYePotCEH9qsj65mfJKQWMwBNmJ08s1bWY5sxW1koTlupKj1id2Hl5kN2/QWQ6Kod4AVy+5
	NqKYgQREVUAXz/vHeZSwmd/U3YFMm4efNzb13kMaM4A0YOVqhz9Zu4HnRfg4ZdioTz2lM9/+ebe
	ykbpZAWUXWqPo2gr3v4ihcad51eXyzgxtYLTRmMlqpOhHp6SEN5H35KI0HqtmTh9+tSjiafG3b5
	AW04F9iQ2aag0YdQiWDxcpSbH
X-Received: by 2002:adf:e9cf:0:b0:47f:8ac0:ccb4 with SMTP id
 ffacd0b85a97d-47fec4f01d7mr3976005f8f.10.1785886028934; Tue, 04 Aug 2026
 16:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org> <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org> <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org> <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org> <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
 <anE27CtvCFx7sAuO@cmpxchg.org> <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
 <7bb32d25-2c3e-40ab-904a-ba22fff60cca@linux.dev> <CAGsJ_4yn5w8b=YQYHEk==8cEc8psB8NHADyrmjBK+YbKtXbdOw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yn5w8b=YQYHEk==8cEc8psB8NHADyrmjBK+YbKtXbdOw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 4 Aug 2026 16:26:56 -0700
X-Gm-Features: AUfX_mwJjN78TuiRF0QYz41n3lYGVIRikrmz3qfdPZfKPuhR2hwMDyEUqT5MYeI
Message-ID: <CAJnrk1ZriOyzOxbd3F+_dAgf-b80ViPaVe8x8_efpkvjGZ4C9A@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, ljs@kernel.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F08540009
X-Stat-Signature: awnkms48ogamqkk6hi4o54hgzmh3z4ko
X-Rspam-User: 
X-HE-Tag: 1785886030-134161
X-HE-Meta: U2FsdGVkX1/ItZWzee5jtStd1nyijQyZf9Bt1YwR8roc3DpUvB095XKsPDxWnRCY2gUGnfJeKKQIRRzBdR6nZa+1ZG56QbQlBS3DEFBIBobWcjGzSGvQzg86etsB4Q9OGxVKw+bC3C3ifhr8+kNAi3kYT4sDP1xrgIiaQdPDFs1LaY/tcFP+AC5SS0HbFuTS1zwlxZ0zfFVhnviupwDigp+sdGM7huU3jhR0xQ02l3MEtI3f/+r97wLN9EvkolcAiKSVuU+mtSGus8y2BQ6u2RoDjKNQIuK1+hUuBANqk7VfNps18RkarkWu5xDQ4OPIG8I+Z8s+kXouStT6HTCcpF/GTejn2zvmk2v/eIv6WXGQ1Tpq77vCZ0GUoslOOnS0Hq6UtEKjXCW+IutD56hONb6YWVYGEYwUadDFH7eXrLAtpMKruE26AVeXYsHbzK30TzTRsDjEukips2lC+pSnGKhkMoPdQiUo765wdjgVx58FNW6nWbguFIbBgjz3K+CrO0rTzEcRygwc0/xD0thXqlKwXdkp327fCnOUUfivzr8Y7z6UZtruxCQEdtyRS+fndtOYihX4g63pxf7m2dV0xyeNtbazSDPuFZhOEt2Wlr3VKFM3BFtPHqle3M39iS72ID4F3zrzSaIRvT6ZvJTHWHgZW3H4gyO6QMDj4Dxg3OiGTQgP3IpZid7woGlZbAgfrrV6YV01WPDvWz5N57BMs2ittqwbcbYnYrFDAFMsTusetIsbPvNWbVDwXgyoGBOKPNQq2aF+zcGU5g7AYqoE8cP90IuALzJHAo2k2j2DQ33EntmMA/VG4eSpMklGgs9AMRqZ+JHYIFR4sybsYx0hlEk4TfS2a98g5KHF0nWhJtwvyr6v0LZxIz9fx4i2LBwNSYIqyzJUKPH4oMabwV15yFvdoP8sK/AX3ztlIqLDSwMRgomct1uIz1jqm4yxLsz4qhBSJ2RwolMXCHHvKQk
 TWq3AEkR
 Ayw6miqj/7epHCN11QEvOaY6NMHjUBGXFrGXPJDRudbgBiEc6YuImOL+vVBxj0vBqSsOfTgUHuERYWJL65PQlAbYSiQaKywxkuIlFG6wcOLLOzFZ6pZyHEJU/3vIuzrWLau65VGa40YqntzUYsEg/QRJzRW1vi6CQe8fHy1Jzx7y6oNLtbaqNbiIu/1K01P/g5KL6DPGTQo2lzG7cH0VCsZFAeyQNOURNbHkMj/DjQbj3R1V36SdlDJaHcYdlndt+DZ1urotRcPBK9dLWxHqosBu8x+g3KAOo7gDscuEJcny+lEVUvmUXUIVSB9yK3IsjswIxXuL+eewfP+4JMycqE3NvreC2r8GUQlzBv65XWHMIRpLX4nZrfFI8hDm0QvlzEA8LEWn2dB5BfOYPiQc3vDa7cCTK1N0SgWSTLiCSxn1LiyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On Tue, Aug 4, 2026 at 3:07=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
>
> BTW, do you see any issue around 16? To me, it seems more
> sensible to use different thresholds for splitting and collapse,
> with the splitting threshold higher than the collapse threshold.
> That way, there is some hysteresis between the two, avoiding
> thrashing around the threshold.

I think PMD right now uses the same threshold for splitting and
collapse. It seems like if using the same splitting and collapse
threshold leads to thrashing, it would also manifest in the PMD case?
Just curious, have there been reports of this? For mTHP today though,
intermediary values for collapse can't be set, so I think that
thrashing scenario is automatically avoided.

If we wanted to separate the split and collapse threshold though,
maybe it makes more sense to set it internally (eg split threshold =3D
collapse threshold + some scale of nr_pages) instead of adding it as a
tunable. afaict, the only scenario where there's the thrashing
feedback loop on the same folio without any changes to the folio is if
someone sets the split threshold below the collapse threshold.

Thanks,
Joanne

