Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29572CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DF18E0147; Tue,  4 Nov 2025 09:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3B78E0124; Tue,  4 Nov 2025 09:33:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497038E0147; Tue,  4 Nov 2025 09:33:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 334098E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:33:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C5E761A05BA
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:33:02 +0000 (UTC)
X-FDA: 84073166604.15.C5881A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 684462001D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:33:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M78uAP6m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of lbulwahn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=lbulwahn@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762266780; a=rsa-sha256;
	cv=none;
	b=uJq88+oUY8PPwRN33guXPcaCifvftRhsU9PwyER5cNIPug2EzPbwPLoufDY23zmqxOlG0T
	PKHqRSLZ1xPN2LlN8EekSGREgHS16yITS1qMipRMQmg9GucIvCR8rDBuyBDJgJ5XcgXvkq
	mi9UfrbO2tRozEJgXQaUL+5nbu85z9U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M78uAP6m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of lbulwahn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=lbulwahn@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762266780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vEZHRadoqRgO4IgyXPFxluBKZrkdYFiHDtDy5XP6kDo=;
	b=Fcbns6aIYP++Yv2G7tMy21PKKPzam/dkgiV8ZspMx5ZlkN1TT1TRf5ARD9FwigxOEWcjSm
	5Tt5hkpUgwIjmsmvLs0HR4GcwPWgWqZPBYW5e1wedGAM8SVmFE979DBkGmow2UrMNubGvi
	sR5jS6gtdNa/UAA5fiQ//abiagU8mRA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762266779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vEZHRadoqRgO4IgyXPFxluBKZrkdYFiHDtDy5XP6kDo=;
	b=M78uAP6mWmp9zD+CA5DH4H/4hapDk1E46uMRTnwLoYMaOf97Wz+2eun8VV7/rxdjyVIY0I
	scK6VFFEoRGpffvBAbaHxfeh7QzOJ9GMjtoAXQ38wF2Abay/5Kv2Wqi85RYTt828ne08IH
	Q4xv9/chN+GZKoT4fiWf5VbQJ+HuWyU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-YgHYA62nPHaTFhvKe0OX1g-1; Tue, 04 Nov 2025 09:32:44 -0500
X-MC-Unique: YgHYA62nPHaTFhvKe0OX1g-1
X-Mimecast-MFC-AGG-ID: YgHYA62nPHaTFhvKe0OX1g_1762266764
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475c422fd70so41808435e9.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 06:32:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762266763; x=1762871563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vEZHRadoqRgO4IgyXPFxluBKZrkdYFiHDtDy5XP6kDo=;
        b=pPtlcPYLPyX0XhicPwGhwKelvTHEtUqVzS+yT280BtQ2kKMWIEbVdtiV+QXwWgBfF2
         amATYB9QmQ0rY1YEyC5km8ZT39YVMSm13DJCpupwx3XWd0ih/VaxKhKwgfMUcIelRRSl
         VJC8d7OS/oV85pp1DAI7J52u5LBfuiuzgAOsexGOm1pMe41QNT6lZURYFWfa+aQQg4QG
         NddPQMnDZzJedC00bWn5lCuIf4p5evma+8rdTBJWY88NdTJuP9AQsttHPjz86l8lo7eQ
         WGmyH3PNUE0h34tJ1IvhyzCovAkMTS487VgiITk9hyjrfu0e4ntr+Ur/K1ZO+OKVNxgq
         G3mQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2ByPMXrl52E2f89kZWq8IFiPBam6qRct7unzX8XLTyqIE/RvnGNv7JSgPhhHnNgzoTaTGDsLPNg==@kvack.org
X-Gm-Message-State: AOJu0YyGonaPdaQnC/8xE0jXHhpVw+WrPT5pXa2XtOkW9Q6JnoF4IlQZ
	XTUtm4jaNSYGM18EhmHWGmjftp4G98FTyZqCeCUuzD0c6W0yBwE6bmgCXPMnZHtcdnxkPcwatDQ
	SYYG6P2TXeWpw3ToLjU1wYU6lcOg1nyN4SlemKQKBxKSn5isNjewG
X-Gm-Gg: ASbGncvXFUJOG2e2mJoeNhIDj6OpMgM5pZkIPjKbzVAsBHUmqD224MzozdBH2VgD6//
	bs5Wp13oGvDahzNOiywKlejeE1zxC+9ZtdPqXzkGNJINmtgK8DM+hZS00GsIBtoxQPL0rCCIOBu
	bWqE3UEu+CWJ+vkQKuiqzim+/bGNuHW9DMQ0BjS4nZxIRI0iyvEiIXPYyPyVf6eA9HTat7g0dwt
	+Amzx7MkRd+byh7Ak54B8l8I1OTXWzEuWIZTkrFgJ+jC0JhY7os60NgpjJ491QNelWsvxuhBf4v
	UGDOOCRd91A3fReXQ7VPcq9d4+uvNuEZ9odqb2Eebg6K4nk+ZtzXczZcn2ofWpfG1xRgDkEPa8S
	DcXDlqLn1Yec/bJgVoFUGML14DNufHGRa6rOsbZbcOSpWjV2x
X-Received: by 2002:a05:600c:820e:b0:475:e007:baf2 with SMTP id 5b1f17b1804b1-477308b6d72mr149701275e9.41.1762266763631;
        Tue, 04 Nov 2025 06:32:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuFO1RurfhxQ8KoSwXSsJCryYZmg5ZaBALPYzQvFuAwcNRk3r60dzVnYtxJMdeRZ/p/LV9eA==
X-Received: by 2002:a05:600c:820e:b0:475:e007:baf2 with SMTP id 5b1f17b1804b1-477308b6d72mr149700945e9.41.1762266763179;
        Tue, 04 Nov 2025 06:32:43 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:1622:5a48:afdc:799f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477558d8a1bsm18898635e9.7.2025.11.04.06.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 06:32:42 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [PATCH] MAINTAINERS: extend file entry in KHO to include subdirectories
Date: Tue,  4 Nov 2025 15:32:38 +0100
Message-ID: <20251104143238.119803-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nZ_RnMhFQ-E3nXEzXkknHTJV6RIdVGWn5IgiZqgW4J8_1762266764
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 684462001D
X-Stat-Signature: j1iqnax3qi66xgku3awtr6njg8eqsbo6
X-HE-Tag: 1762266780-933223
X-HE-Meta: U2FsdGVkX1+xafB1JQGKJqpeKCDZHrrlxwaFYimw/GdL36s3MASVyT5Hq5hkrixgDaH8YuxvDO8ISfoJ+bgqiiSsVbchkOQ2e0/kElwzhQq89be/23PskkcIYsZEy9RWkvcZoaaQDTMY6pEkhwPFShpuKkGEV0HP6T9VWBcK4WhA1Nb7cuX1/QHReBBhqA/Gwl5lT3P0TCTQHxm0Jsb8im/dJdaeMoBjMEm+CP3ouXBxJbbd7lPBoOkg/SvbUWbDgvhbJr9ZJb4Nedjlj/pfqRQSI5y00tJzpbdD3SdgN5C4ysjVOTo4WexJ2GjCI6MzdbMGgiGVCjLMT0a66om83JuaeXbnIAAG9GXXHHmvyP3aYzNXdKTXOdYmYekJzoOPlBFIbgpfpD067kUae24tiaH1EMnBEubxL+E8ezDu06YO7AN2Y/ljf37ysIRZxsURSogo1tINOVxasgvmMe5d26Wc9VNfjh18iNn+AI4r7F9E1RqyrS4xPxE2/I/MWCT4sNuhLPs8nMa8gMPt+1D5RYMtQO8mgiSnCK8FQQjUn1gxw5loQ+3W7dGZN96K9K1enNV0GziY9VYtE8AvMNT2GMGhnxIBkBzZ23D/7I+WPU7oNZVYf76f9Y1nI6jZk8noj5DX9Ut8LaJ5Rws8AZkp04Q9wZh9IE1JWJDRuW9Id9qcWxaPUwvjSn0uVuGmOys7uYu8NoOvPtidpbiTXuq3GB5YlgN12AhQ6hnaMtR9ZzZ5yl4iUi486mCIW0q0+DKWkis7BcPEpox6YbJEp9CUZ1IbQ0ZyLEmJURoPP2VhM/VKXYPctFt8S+MQ+29qjRfUmyT++rio+hTOOhrAcZ4c5yLKA9F4JZVz1jp7iYh1sjdm9+snc3eZ8Y72GNk+Gs47smZVs8dOW7GEVosguMijXbViTVrYr1B+hZ/O3HguFUm6MtQoF5rKJK7Ens6GPMFZGjO30dzagCuJQ10Cph3
 Byzzl8rg
 8V3JQeojmIHJia3j8tzVEwAXs7N4C3BqaVa5WjhVEU1LEFN8h3e+5l9y2Q5wjiWz8IzeZJdYoZ0yqhHwye+LfhjKoQeq4mNFnGk/ll4uoHui3SZ1NP/CVGI4+0EoRRh2WHdcDvgxpykU+nYEMW53bYvnATDH6NSavinNJcDDcB4fXIfbdbrf1rgv9PJ5JJfwv8eDOI7ZVB7yHHRY3hQhlAk/mz4JA1MekHgUoi4hTzp3Tz87WwCPr5jY1edMcAqp9cPavckPUl13to3SlN/oZtKX22C2ze1sHA9i3hgfxGB7HIRzhW8du+iYLFFnc1NerwwqWxqTd5025bi55xu72xNiSD72r57o13OMLBAP2KjANlMDmBV8bkCvJx0SUbmo3vJ4mZFM6e5np+/BVh2cStM1U4sp1vid7Y2xI3EyoS1gu3Yv9HOnKwEKh4rrASxtX9etVIpJbmhUqG5x1TPVN7dLqBKYAR2N6/h+frYJVvcChgR3FGhU8LKPxeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Commit 3498209ff64e ("Documentation: add documentation for KHO") adds the
file entry for 'Documentation/core-api/kho/*'. The asterisk in the end
means that all files in kho are included, but not files in its
subdirectories below.
Hence, the files under Documentation/core-api/kho/bindings/ are not
considered part of KHO, and get_maintainers.pl does not necessarily add the
KHO maintainers to the recipients of patches to those files. Probably, this
is not intended, though, and it was simply an oversight of the detailed
semantics of such file entries.

Make the file entry to include the subdirectories of
Documentation/core-api/kho/.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 06ff926c5331..499b52d7793f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13836,7 +13836,7 @@ L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
-F:	Documentation/core-api/kho/*
+F:	Documentation/core-api/kho/
 F:	include/linux/kexec_handover.h
 F:	kernel/kexec_handover.c
 F:	tools/testing/selftests/kho/
-- 
2.51.1


