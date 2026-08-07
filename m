Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB073C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCA16B0096; Fri,  7 Aug 2026 12:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CDE6B009B; Fri,  7 Aug 2026 12:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793B86B009E; Fri,  7 Aug 2026 12:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4A46B0096
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:18:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA40016033D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:18:35 +0000 (UTC)
X-FDA: 85074981390.24.AF2AA9D
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A7812000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:18:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ndPfFjwC;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786119514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15034nKXWgrfjc3mE03PSssA+Qfib9RRfUt9G57sL/M=;
	b=LoSeiFjOvU1rVwr2ZCLex9lu9+7QGDZMmwYjZQR0GV/E7DjQiZY7CmfkVDfwWo0mDuJEPJ
	eOuZgZNJQyNHEjQ769dvivgCkqgyNP4GYBmhIrEZQaBxf9DMCwnanRh31jJWDcL5jr2pOa
	BCMcUAOFFhjiRFAQsXyKaLvtWXMOSRQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ndPfFjwC;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786119514;
	b=8iyhaZ4gaxUgtNq11v0e/nqPbhGNVlchjD3njHsLeg1iUaBdzaDfu0hP1PCeTjh/YfLJc7
	OphS/oPklSJY4phWDS12XaMC+AbrhuTPUARxNNM1xZMRMV80yAbcdbDhhMiRc6TaaQ6nXw
	anL2aNVrOpOA0TpdFo2+diTBUHCkS6c=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84f38f3b36eso2605090b3a.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786119513; x=1786724313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=15034nKXWgrfjc3mE03PSssA+Qfib9RRfUt9G57sL/M=;
        b=ndPfFjwCv2NKHQmQlezKNLbqmrzC4ZCMnrYnwZW0GRnQkqDc61O3F6fISH1kwuYF9O
         wqxOZP6bQSgxLpRwr94Taz+ICpHfiq0arpbvBrwgIp4k/J6RmIY8oAfz+zeCa21MswY4
         WddPh3NGfg+1uxX7n1WSTQmQXArDiv+2Oy9vd8KTQh5gSkwJ0AT9goBJLF3xT0DPs5Jj
         kNc4dOBDspKNHdkZMX4cnabBuNMNoVWdnUkjAzvtwJPyuoVnI0K+3uJ0DVWqzWCncV45
         CtrM6KKCaGsTK5QVfo3AvEmwD3QzDH9MtXSNO0SKkdhPOZsmbffcj5IQuzrYUE+PJy+W
         O0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786119513; x=1786724313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=15034nKXWgrfjc3mE03PSssA+Qfib9RRfUt9G57sL/M=;
        b=GmyDfd9aMS0Geam3Tub94W5JHPnYso4V7TwO3JXRHK2rXGhra+DH+G4GVQmXnvRbNc
         +mRAEzq2glOMCAggA4ttiVEP2fNA53PbAqtHunHXCGONyfsoEXBmpvQz7j5VnQP0X2Vk
         VikPHamtSYBMxXmeqn/ss1IqbzF0deHA76P90kNQWiTsYy9Z5msLZcYFjcEvNMThQbCH
         P0Nj+lrErH4HadV60HNp8u6VOL5A0hbkOqavozUR9osuTsHExizr1UwLZnPTSFf1cdeY
         UiXMN7AUQ7hrQFqZSUIstTSzxUen+IZPQtKc8NyrxA0kCza5LtARZ2YXBWKYwTcgrYyF
         h4Lw==
X-Forwarded-Encrypted: i=1; AHgh+RryBJtwjTIKL8zoY1IaxNzvw7dj3XxiDMrX3AABzh/kjuBpPT1PFMLac/CIoSgjQ+eX+iDx795kFA==@kvack.org
X-Gm-Message-State: AOJu0YyPEnQq57nnHhkjwEPkovwnPSI0frCfJ7+QsrTazRFCUI8gp3Bm
	pYQJXqoW3WQEu4e+LZBHMXiWWcD1SB0et/RvIDbJAbFTLRV8YcY3Svnk
X-Gm-Gg: AR+sD12zoAzXMGYMunnpEMA88baT6uzlhL6o7FTxKcsydqRsLoOwx5+J5RTqy3YLRmH
	fj+Qzi08APZ5o7JPDcU+6eZ3THese9H3bq5ghIiU4P3LifKRwu7664fBfgFMtW4GSRAA96mTy41
	+RY8TOtrXLETmRTACG5dmXCUrv9PloddduTj89GyDn2IIkuyWtQZ2STdZ02ZfJMPTR6cIrliADV
	Fcax5Vt5TZXYb0nNYWFZHx/MAyuNiP3HVNjWVjwXFaTkp0sLH2a1XiyMMsF+AHyj88zbnJejJxx
	EVcRdUJ17Tq5Sl2HryBcKZ1TZMjyqP0vfgzyXJKkj071KjwILNgnUvjZE8qZaorRjwbdLDBK+KW
	ZoqpDmg6cTFTzFyI4nwgSRZRckTuMrrZW5AwvFOQS7D4or5tzfanekoUFJsCZ8Egm0bADknVlkx
	4hBKHHajF2NVVmk2f3PEaws8NFlvCzcCXS1ghyg7sQ/KWxLFETc+nvwbbup8Jb4UB5IAnaZN3sq
	IJZs84xOArRzdwJ
X-Received: by 2002:a05:6a00:399f:b0:848:42a7:1854 with SMTP id d2e1a72fcca58-84f4fee21bemr11529881b3a.39.1786119512747;
        Fri, 07 Aug 2026 09:18:32 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:935:f4a7:6f5c:e816:9aba:2090])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a3d1155sm1318232b3a.20.2026.08.07.09.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:18:32 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/damon: skip deactivated schemes in watermark checks and add fallback sleep
Date: Sat,  8 Aug 2026 00:18:40 +0800
Message-ID: <20260807161840.56993-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807140739.91238-1-sj@kernel.org>
References: <20260807140739.91238-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mt66uoqpj4k5ns939hj9y71sk8hrccfz
X-Rspamd-Queue-Id: 1A7812000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786119513-236740
X-HE-Meta: U2FsdGVkX19XILU96Rh+cTeT+Y5hRVatAHreQJqSpQ0zlok/H/vmV+HZO3b53yWsmXr/WZy4Wowh9zIxOzYdJPnzqhmn+nWn86cGXjpKJeEV3RV66tylxPSxg/xYcwaoUyaEX5SoO5RQvLwKX3mT9IGsH1PnXl/Y8lo7eaORb1FipWVaQOXBNMRvEmIPS420KEgLTGCQPiszxzjoL8MTVBB45sB8BQGo+upRtZoMuzOxSb1WY93j4uQmE8s27b771L/UgEIYhZuD4B2mlQwtKrJYEUD2D8nVPRynyx1m8Yotw4rQAZLuSlMcEml8KeivcP9MgqS4Hmf/TKv9lZBcF+pMkXnaD7SKTbXpxIyLt7LNCx7xUICGpScOSCQoHJ1EhIPmHb+MlxnMe6qPmnJ00jNkS8oq5xQgXnGii/YO7XSwKb9XHcu0kSPHD2ejVcVxGqN2XzBipQw/s7tHaI9NpNqQjHrfwsbycnGRSLyYrszNt9wy7o+V1rA4L9Wjvr58LwMZr3q3ZnxgLitL6t/C4KwF+x74ABYBNfNepjiEQhOoLFGUC3ObNtUcoOD47VGTSrvjKZJhHtuxPWFGyU2+zaDMK7QZMlHWkGJw0jpRn8V/A2+NHSQ+9qUhCfhtbjHez7L5IZd8+NNPjCHmiSRSpZtIrwJ76EJt+S5cZXdcg9Xy83hwoGtz5vVdNNK8yuwtfXOjp6OGh+IvVT6lo4b8wX7/2LaY0K9haPlqon6j9HzYHvVV7IiIwJr1uUowDiQGh4C7Bo4RB5gNZVX1oMn3yGi3F9CsYmroTXqLr7Zz+I9b+qRao6rprL2bQ6QXDNyzIgF9poAPyczg+jg4HSfEp2QEJm3Mg8/4qJsz7A771ARpkV76q8JMNfeJe0etTTOYw5wyklOYux/+rKmyGkOsCbLhbKkBLMen2+6BiTXcPZTQ/IctxNbHfLGW5hhXveZQjqzXdOBKYFhm2JRpko0
 TpUt7qQn
 FNcuq8M9a8idLjarE/3S7ilo3YX+mcVmpVigtiHwW9rZmMDR1YxzaUfKCjdnUUYOVR1UDxRd0YortDKHFxm3/fWyYkJZllDxt1RN/vZ/Oe7wyaN894Q0GNX3UFUFySVm2LBns4iyxu5nkpdGDs1L2jm3qZuYvh7MEabDxUVOGp3eastCyXDqPj2aj3G8IeEhr6QSr4cLk7kM34jsRjI/vRgB7M70BEX+z+IXvyjSDzAS9hI3KZMKwjcxJ6GtKKhCELGyrBl5hbK5ObVZNgrLz1bInfsRDI00MGOO5ZiyWs7YSJWGF32oVF0dJ+BGuYJemGyxu9cuVJZfuKgEV6JztacRHn6moLFei//Sp3AvwDtoV/eMgh73SI8R33Y17oBDrQPUjMli+1wcKzj2kkYCGjyLSSilRFFraEE0+Gc3rmj3awKU0bgNq/aJvzqagYv7MOU2zK2m8mD9+4b4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Fri,  7 Aug 2026 07:07:39 -0700 SJ Park <sj@kernel.org> wrote:

> This is an intended implementation.
> 
> When all schemes are deactivated by watermarks, DAMON stops monitoring.  It was
> implemented in the way because we didn't want DAMON consumes system resource in
> the case.  But, later it turned out DAMON's resource consumption is really
> negligible.  Rather, it is turned out that it makes DAMON runs with stale
> history when it is activated again.  Particularly, regions have 'age' and their
> start/end addresses that was emerged before the deactivation.  Those are
> meaningless and could even cause wrong DAMOS decisions.
> 
> We don't want that anymore.  For a case the user really want DAMON completely
> stops, we introduced 'pause'.  For max_nr_snapshot-based deactivation, we don't
> intend to completely stop DAMON.
> 
> Maybe the documentation can be updated to further clarify this.

Thank you for your detailed explanation! I also glad to hear that
DAMON's monitoring's resource consumption is negligible, since I plan to
add a contexts/<N>/always_monitoring parameter later on, allowing users
to decide for themselves whether to keep monitoring even all schemes is
deactivated by watermarks.

Best regards,
Rui Yan

