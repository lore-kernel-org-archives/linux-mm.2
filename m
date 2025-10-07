Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CED1CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F708E0015; Tue,  7 Oct 2025 08:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445858E0005; Tue,  7 Oct 2025 08:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1228E0015; Tue,  7 Oct 2025 08:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD458E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA65E140165
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:49 +0000 (UTC)
X-FDA: 83971227018.16.D4C1832
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3E201C0011
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MxhvVhiw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTx3t8206FADCajKY+kyp/2YAJmhuLjY8XEm0uYYaD4=;
	b=O0rpWAUFeKds14xHF7XmBkzVO3UQ640Uv5ZyYt4rRJdenFVyt4OyvArP6c99IionWK+icx
	cj6Xxsqk86mogfNwhvXUTuM4gnij3bIp76jkttYzV8xyx0grQ+WLdPIDqkM3se1kmsKlkc
	OXTHYInfz1IIJPosSb3d3W9MJLglOO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839647; a=rsa-sha256;
	cv=none;
	b=f3s0Ze+fG1kwuf6NKDXKnRVhyxxsAckpJTu4l9SbhP7xY4h24GC4gbPArx8wh3XFPJn92r
	YzDUvoPmZ36D43uT/AbKpSCzY5AC2Dp7thmuS6sfMZzl02Y20HYaE/PwHe7QCjpfepxmKc
	ZrrIUXwgzZgPC9P+wLv+k3eXUEILNx4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MxhvVhiw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-57933d3e498so8481196e87.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839646; x=1760444446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTx3t8206FADCajKY+kyp/2YAJmhuLjY8XEm0uYYaD4=;
        b=MxhvVhiwGm2QiUlvjoJDupwpYdwo/ttuLVgyfaF9nGsnIVKETra1TJs+4bu6RGrCqS
         og/bvziuqwdFkQACUl0ZO0QS7WMvLjDe+mZLUUJKBbq+4Rx9juDEFsuSE5BmdLXWin0E
         5SDesdPX8bMFMO2IUH7GKTAJQ3LdKpnatZZMQfNMOoJHo70nqPPgv4fpEbE1F6r1sopv
         QwxoM3/F7L+/rTyqYiBrs5O2roLMdGsydWI3XhVPfiAAV4hsIVgcH8IWTIKhJSfEean6
         L5w8q8F+gfOMTCHLIs2Lq4LqKEq4zFFC+AAQwstuK6cEmXlGdi7ElxloMy3KQYsBmEmf
         AMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839646; x=1760444446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CTx3t8206FADCajKY+kyp/2YAJmhuLjY8XEm0uYYaD4=;
        b=kF5C/pZkSfeWL3zXvo+MoW1tkos/kL42AM4oJ95Aody8GTPNomA7u+Zu1/1meVARV1
         o2pA7DlShOf7UenkdqPvrkxZhR9QxmTynNkfEcRHVTZP0ZqetvnZ6f8UaN62v01AR4gJ
         lJgSd06T37JthtgeXKumD1thWXJFDDW9NVUVFOBehpx7HO/r01xCdZ7zco9AfUzV6IFv
         RyM872G7yIU38JA4oKKBBywAz86w8a8g0dkeIJ62wRLipE6lWAOPKGV1UkAcLZLlXJoV
         +6lTiJNkSkZxQd53hZXTPNwj4Mt5Gdizl7I8Ha1eRLeA9zYLmkhbsTtQGzNJv1KFN5bH
         wLUA==
X-Gm-Message-State: AOJu0YxH1Vw5HsSqITweOGwhKuWz1LzAVx0UC2nzMIhluNE8OQGFp3uz
	VETTxTVBbQEpPnckLKVQXomsUjnUcw893/Rxo3ZYrzcfU6kxdGuRBAG75L7poTFO
X-Gm-Gg: ASbGncutLL3A/TH85K0UMXrRyjZ7EmaqSiG50Y1S6t/L+jyFTBFnSJq7O0bWXySOUfh
	p/RjUuPG8+2vIoQIq9WXYI71isTqJl2V32wju9gWpAyUUsR5vETXOzdPiCvqd7lwYPKWOytp032
	nE92NSTsnbNbX5UAzgg9A+ot+4/F1g52TV5ITF7YG1INc2iOAmIzuY0GufcUXkdDO1PHayC6Ru9
	elTOv45adpQoiVvlWvvxuuHPDoPpM3tZfPw+kJvB5a3lPmPOuNZ9boM+7lqs73Ldo6ZF3bSJNjs
	9OWkhDKIPpvTC44nlXYLOBt/QNQ28QZjkAJmGMTaYdeLtxH1DJ837I+h8qs4TqL7SgJZtLbrleg
	pvfnUw/cMQACivyGFsfs6XVHCirW03g1Go1thF4GG
X-Google-Smtp-Source: AGHT+IFBISJsnLRLg6R99DyCufi90oiGK10CgIZ6THuFjlwNfx/elYDiBcir+/FIn6ZcCpkoSUOyAQ==
X-Received: by 2002:a05:6512:23a9:b0:58b:6f:719e with SMTP id 2adb3069b0e04-58cba6c1968mr5532094e87.17.1759839645937;
        Tue, 07 Oct 2025 05:20:45 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:44 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v4 06/10] mm/kasan: Support non-blocking GFP in kasan_populate_vmalloc()
Date: Tue,  7 Oct 2025 14:20:31 +0200
Message-ID: <20251007122035.56347-7-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ghzbtg5p7n3gd3pfhcuytkgk5uybhwop
X-Rspam-User: 
X-Rspamd-Queue-Id: C3E201C0011
X-HE-Tag: 1759839647-932029
X-HE-Meta: U2FsdGVkX19koOti6jxlUDrQniMDBYh87tpSYm9GwLwodKPzsySZM4HALOf1p/AjFz4/ZKzkRJjX4njew3QWz4hBHBMb2leaNLpYLaW3MbFyN0QkClb/VDcISKAgMtnIBwKbnzeGJdq1FD1Rmck2hF9JSdhBRXOt3MktnSXSl+pKJdurOX++Q1Q8cG0fmWsU/RSfBX4Uq3GMWP+qBq9gGyChj1YgNP91ShHiLn4hWeCQYba6d+Df/1fskICJ7Y5onciiHtoQOBrc528cH3HDT7KFsDBCoCP2xUENrtOsSe7IoPea+h0fkURjUdLxWGKai8zDv9a5LLLDGibuYH2ShgRT2Sq4uVBtElyAOFGRYnlUtun5+C8cHiwGxc0rc5ebLIZRcd58mjxtbmWBSj0it20UcVeioSNobeKtgb/eT4H8oRYbKk9YWcfmAOhwN0WzVzqoCFXwbMroOEVFLZaJ4elSpHH7eMkp/55sMXFjFrF1b+u5C7D7QO2ofE4ciWm2Sk74FmXwO+43ZEuk+0KHtlzujCcD1X0ReSq13iouOrpO2WUj51aYoLpLZjxggms0GpfnE4clWDEcSa7lku2jq8y2ssai2X5FlBrPW5/5gVI+xdze44p3qRpKx/9Y018uV+KOGtm5z/UMA34yaXdZzNfDuDsJd4I4nY5Dr7rbdEOSw9YuCZsDxfj8SnaZy4Y7L+SK2QrIQsN+Fmf5C90kdvrLT30oj21Lj84DzQAm3DclpTEeOp+TdL/HS1RWQjUJqJIXiAJDwVNoia2doR6fsEBnH5yjU8+rGV7iXB465v7yZoS9R4llPNY0Sjiw4L08hDQ0PFSu4zSzlfEAMOcmDS8yR6jmRF/4C3+NGNvb2ZrW6oU9jAtMkN/3uiIg3xPOHxFquf/fTZ2SZtKF8FL5RVVSByn7ef20z46/0KHx+/kpKCV/G8WWCSZxcHvt6RG6/SOrnoZ6DRjeDgjKdGa
 FLfuc+rm
 n1YnFFHV087YghY8al2ltGaGbryw4n98TCce8TP1r0nq0qeuB83KDArWsLewERX+FziMd7PzEUu6Ss7COIEk6ftIgH6NPtvj/Vazw4APeKp7C2L04TbNnPVf8Ox/V2RAkZmw/lnLBgwyCochSLT4r9lItz/7q7qXbO9bbxF8R/BkaTSAIthPcKQtdS9ogvigsKS2B1Sx5KcZuGf9xipIkEhIW1nJVM6DI35Zh+iOOKIAWeICSe044Y+Jflazk2iOGUwDcYRzL2sLbuN59WYmUtgzTT3stzH3pDQx25g8odGzt5+0TJgYUwWpPUPjgIwNWUognRT8WV8tSjgCGXNeKrZFcJvbWyF3R3pXpWuKZyeejTXaj6xQtH0JzlKBANhxomC1feqMsPLAs257Ii1Akj/NTtgSevHI8DdvLoxl0K7qOE3ABk5smVdDCugEkmm7qaLQwEkacxx5eTA3B1T7TwejATfLVHOJ655IvjFGKdBdN70cRLqmJ9n/mtymH2NyWI3LphjpQsg6l2deMj8CqTyZB/685I35Y92cklQINNctREevKj2rXRMVV5LmBrWiH6c2AS8aPnWPKhuk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A "gfp_mask" is already passed to kasan_populate_vmalloc() as
an argument to respect GFPs from callers and KASAN uses it for
its internal allocations.

But apply_to_page_range() function ignores GFP flags due to a
hard-coded mask.

Wrap the call with memalloc_apply_gfp_scope()/memalloc_restore_scope()
so that non-blocking GFP flags(GFP_ATOMIC, GFP_NOWAIT) are respected.

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/kasan/shadow.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 5d2a876035d6..a30d84bfdd52 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -377,18 +377,10 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_
 		 * page tables allocations ignore external gfp mask, enforce it
 		 * by the scope API
 		 */
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			flags = memalloc_nofs_save();
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			flags = memalloc_noio_save();
-
+		flags = memalloc_apply_gfp_scope(gfp_mask);
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
-
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			memalloc_nofs_restore(flags);
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			memalloc_noio_restore(flags);
+		memalloc_restore_scope(flags);
 
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
-- 
2.47.3


