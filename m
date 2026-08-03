Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3DAC5518F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9BA6B00A5; Mon,  3 Aug 2026 08:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53D06B00A6; Mon,  3 Aug 2026 08:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C428A6B00A7; Mon,  3 Aug 2026 08:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8446B00A5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:54:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C8191406BF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:15:33 +0000 (UTC)
X-FDA: 85059853746.19.38AF12D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A67101C0010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:15:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFKPUPrP;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785759331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=poueR7DfB9aIGfWVmCWpCQzsUcIx1p6d9MpQRvHzhFc=;
	b=ouRnxK0KxGC6mZsLtZh2VWib9Axh5Bqzgw6LRrWgCdwu08LfU3a2XFsYbAvkH1xMjklM1z
	asyB9OwBxb6Ali7nRIFlNZL+kpQxfMe9/uP/ccYzdFVJ6vQSR9CoJSwxlbEz23dvemQ27K
	igzi2u6SOAZwWflEj+RoZZasRqSnFYo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFKPUPrP;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785759331;
	b=TaPjrJS01errM3Ydm/9cQAC3oAV0P7yo3Wfpaa0w2XLnHgQG0Il8O7zvYV2wrbM+NBTpV4
	yw801kGLSYfV6hYKnBDDTG1pvZf1srqhpcU8+g1zfju0zAC67vAqjx+GJ3+/k9rHn3kWay
	LfbKGHJeKW/gaYSK59LbTD3tFIyqSZE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AF7C44022;
	Mon,  3 Aug 2026 12:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F6E1F000E9;
	Mon,  3 Aug 2026 12:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785759331;
	bh=poueR7DfB9aIGfWVmCWpCQzsUcIx1p6d9MpQRvHzhFc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EFKPUPrPVthfkr8KU/etmkk+cysO6CYYC+ELmo719CZWR5PhxFFMQsC5n0aIoxd6X
	 85mn1cl1SvdTx+AkJVZeTWt2+Bg2pd8W6RS1xY3pDFP/c50ZzBbC2WColtvL3ZWLpD
	 jkyj/mVmPKqUvwUbcsNvgLxtR641CCzOcEhQgUGXtLdwj1EjQgTJt4VDGcor321Gj6
	 u7dvmsh6JxE8X6Qqjlz1cdad2sWuhECnWGjX/K2wnoaGXv2flIAWzJ0dEIRPrqFWIp
	 ZOTyBCM0R7d0LdQMI3R2iRIISbftI+I+ypvr307yqDIeCEn+BW2oH/LnsCsa83wx9t
	 G7rvEsyxxxFrA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 03 Aug 2026 14:15:02 +0200
Subject: [PATCH 3/3] binfmt_misc: document the pre-opened interpreter limit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-work-binfmt_misc-interplimit-v1-3-4a2435500bd9@kernel.org>
References: <20260803-work-binfmt_misc-interplimit-v1-0-4a2435500bd9@kernel.org>
In-Reply-To: <20260803-work-binfmt_misc-interplimit-v1-0-4a2435500bd9@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=2057; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2n5y7obkLAnf5oBtFkR2gN8H7OTFfUdPsI44hm+1s90=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQVtIVlPlu66fpst9a3+8UeB+9cvX8e92uvguBznxwkT
 rIV7ovz6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIMlmGv+I7X++6Irt706Zd
 Ny2iD60T5HoY3uffGXWY9z3zfuFjZ2QZGdZu/MS5LIbtE/cs+ZWTpz8SOjxtm8XTo6sk6yIsmue
 feMYNAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A67101C0010
X-Stat-Signature: 7pnqsi58ct9g6kyrizwxn1ibercekjrk
X-HE-Tag: 1785759331-325956
X-HE-Meta: U2FsdGVkX1+TQ1/n85Uga4h0L0Serv5TaC0rzVJB4xAB81EG8mNsM+WpQZu9njaUAjZmRkjvEOafRMBwrxPFdI1WyFVXuNJm5COmzptq17u3qAxsidhN9WHtP4hJoZMubI0Swc/pnrBuBbflQSlWS5lHDj9gPNBeGznK6hg2E2A1djIdkeloDb2CqxZ0W5k1At8bpChJn6P5P0T/fcP+payt+yJuVBAOtIyCMs80IcQlmQvVomZfJAwdKeMT2EDvUQF80frku1of2wA1ETmFtPajri7WOzpTqog0QaC8uVWp/edkZ51UQWKu35rKrRqQ1dRDE0ePNpMDlK2oBbnX7MHgDfvOlJIYgGk3pZ5u9NrV2efHc2U0tKFfMZxCwP77ELUzPw9jK+su27TvTfvuftOn1he7JvS8qWuX861Krhxl2B/cVd26kNqayv2eoanqQ99wmJOh72AS4Pz9aGLssrOuol3rNhI0O9+4AMLuKd48l2OD7t1udYkuiWp95/rVmDHf+Q0f3mlD7iUQWnZXBqWQ8Ow3uTjU+DaKkGBRBvgdYDgB2GpyVpsH5BkRCv1E43T5/PiTaiXpRpHgy8zYxkmRbVp8O429bX+sI9TAjgMD9fcH+Qui1cRl14VsMN4p6jp14AStDdfQ/GdAegjOOpVPTMlEj7qV4eGbSBd2HrO4tLP+iFufJXBvuYBcKhKnIXEajLJZH2Rk9RgHlvvuLwPu4GEEnqYDQoP0Et2kEJ0UAUWOFEuKiKtAgmsOPAW2T0WMZgtFBzE7tg8QOgk7CzLgt3BPtdJ9A+ffuCtlRvPF9afV9NGorjkfqGp84ox8156a8nk3K+6CAbQ5TeaMwXpOffBRhU+Nm+pGBuDRE4NsM534hF3DZOYfoZs/gxZiqPEULxfyebLSF/ruV0m/9fGV9yr1hljdIo1Ncm+Yw0xGS5KYUlDLId5ijKh9q4SfAmQHvYJbZ7vYMvMD69w
 CIRX9igX
 tCxkWuPwha/EaJX/j8CIRAXpla+dvO7zni1sHKEdxe0DczbhpfN1GjKZeVRZUNdz4XqqHWLYTs8ftMQdQV8ye9q70lfG2wGdnqdhqpsAMqFa2dp4ul+vyoWRwWXT79goi/g4eTtFAKatIkNg8kGAlAiy9uJPPOAvWcHIsw5IINVTkgaOxCfC7kEd/V2x/2DkIZwPhkpxPgcwADolPyEwS30CAlPqFYOLLpb9d3xKQva88WmrL1bTcEMa2VfgwvRQDHevwIE8nb68CPBR0Tbukp3Q0SuQIMn1oXuDcIfa82mI/HO48qUkmcIDaaoXsEYSBsvatYLpXsVQ2VBzKkRd1ZU+H369sLO42KC81HMOd2vU2VneJyLpYEtTfKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document how pre-opened interpreters are accounted.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 622b5d8c8995..d26b63a27c25 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -128,6 +128,11 @@ There are some restrictions:
    named by an absolute path. It is opened when the binary is executed, so
    a relative one would be resolved against the working directory of
    whoever runs the binary
+ - the amount of pre-opened interpreters by ``F``, or bound to a ``B`` entry
+   is limited by the ``/proc/sys/user/max_binfmt_misc_interpreters`` sysctl. A
+   registration past the limit is refused with ``-ENOSPC``. This limits an
+   unprivileged namespace pinning files. A nested namespace can raise only its
+   own limit and every ancestor is charged too
 
 
 To use binfmt_misc you have to mount it first. You can mount it with
@@ -215,10 +220,9 @@ with the credentials the entry file was opened with, exactly the way ``F``
 pre-opens a static entry's interpreter; the paths must be absolute. The
 path is everything past the first space, so there is nothing it cannot
 express, and no interpreter has to fit in a register string. An entry
-binds at most 100 interpreters; a write past that is refused with
-``-ENOSPC``. To bind a file that has no path of its own - already
-unlinked, a ``memfd``, or reachable only in another mount namespace -
-open it and write ``/proc/self/fd/N``.
+binds at most 100 interpreters, and each one is charged against
+``max_binfmt_misc_interpreters`` like any other binding. A write past either
+limit is refused with ``-ENOSPC``.
 
 The ``load`` program then selects one per exec by name with the
 ``bpf_binprm_select_interp()`` kfunc, and every exec runs a clone of the

-- 
2.53.0


