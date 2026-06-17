Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555B0CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905386B009F; Wed, 17 Jun 2026 10:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88F076B00A1; Wed, 17 Jun 2026 10:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D29B6B009F; Wed, 17 Jun 2026 10:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 374A76B009F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D0B01C243C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:39 +0000 (UTC)
X-FDA: 84889685958.20.AF82372
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B3C5180003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=newO6kd6;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtuACU05uWFEz+Ei+IYVVZbkflRFGPIDankdmmStN+4=;
	b=pStpt6gSCqaFPAd3/fLmo4fHHjonbyS27QRujSkSHSeB0kuyRFJBPcjmh2EjoQEDbCeovt
	1fNd6CDA3QS6t46uBZWSeOhYEWXIr0AwCHEBY3TudwEc39zYsfGN8nsK5PTJoGcJ3X5jxq
	WGZjO+GnVVhpXnTrgCOWjy7eY/EKALs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=newO6kd6;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707718;
	b=l3gXPB3zFO/BAqIG3dNhpC6I5DKMDjqC4hFygjeaQ1oE1DukzakRWJmhSIko1gnFnNw/wp
	8hTFBLF1Icm0r9sDKtKRSPngDrzKGqTlaprA07oie77qwtjIzN3SysbTU6nzp2C+SGk7pc
	XCKK8K8s8AC58fDSmtr1DFNiB05Q/l0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53B7444569;
	Wed, 17 Jun 2026 14:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FAD1F00A3D;
	Wed, 17 Jun 2026 14:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707717;
	bh=YtuACU05uWFEz+Ei+IYVVZbkflRFGPIDankdmmStN+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=newO6kd61rxUta9sxfOW/31k4cJ7NC+z7HUfEnbvZE8UgaW1nrLrktwr3chXpFcsm
	 dzdlN4eHn8jhYQsWOP3Jj1CJAb1CBco3QnpH6DKglf6vNQMypJLg2NZdQn8z6P5AZR
	 wSlSEKkGLc9DUo+Lex+3ZloUY0cdJoiNB4ZQl8f3LVUr2uvup9ADPAcQudhzE0FOzZ
	 Rn5+9uZEZum7JLeV3YQLrz5e4wNCBfx43sQJ8ompkyOIrLsSWA0d7CRwXl0WwLss89
	 C/uDRIA2ueWQcgS9OumJon6hYbA1MFUJbW0mCyY4EgitmXOCLG2C8q00Sxpnbjx1Y7
	 DRj0FwuCfpctQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 04/11] mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Wed, 17 Jun 2026 07:47:58 -0700
Message-ID: <20260617144807.91441-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0B3C5180003
X-Stat-Signature: 3sg8wahijsm6go87h7ytfph9ba6xftzj
X-Rspam-User: 
X-HE-Tag: 1781707717-969777
X-HE-Meta: U2FsdGVkX1+5rf8wGXIfMo/37wLP7epk1Kh1q/81KTfUn+ws9hf+7PR8NbHmr/h10qyccwGhY4Pi7lFlVhiuAGvDVPf5RehmUOihrWppaSsYHW8u5mt+SSTMeJ9bfPQRm70/Z6obQo0KVVB9MnRDG3RSpQHLlCimDIUmgxptFERR9qndSJlMI//Z5eO7i8kLfa9tQxYlLfgq4MJeefx6VT10Q26aux695Oppg563gR/AtDQ7sDelDFxn2brhULcu7p5SUCnybdJmmonFkCrbConjNIxOo+M/s7VS2x9v/Ja1Hum6wrJ48XnJIRf/ROSyvLlAVMZEO9HuADiQdjtbta8dpiWWt/umHBTJpBsSvhFQ6dy+9z8Asss1KNOB4vByqzcas3q/qexuO+GWbZCUiZlFB3gq7KTy8tARm6jsDMumOh4pIjfAYOpD4bBUnImsC9Ij5QxTDvVWlO105nD3fc3V039JFVRb+sl1wp3LGC+0fEfS5KRmEKnypaA3AkyW2wW6Bxp+4/a9c71URKH9mlxxfFrh6K+TiFYgMJ8yI9quC679n64VALV44YufMbnzlkYjfZXanxQwLKiL7UX7P8wajGvm/lMMnEIjd2L5igpGjasuc1XQ7v1CeFGk38eSZx5nwULNfWR+NLxpy/zhzWkUtMIMfN/RkcFsk4tmXaqJEcIhIg0Y4474fS3le+fDXp2Ft4fj7aPdBqwOmhih81gacNbk8qS6cNmUBSej5bk9gLxZvGyBRpCTgoFevXZ1dpxxajNDroEx1tcoYwK2cYL/t/9G9y80r27aRRbqrmsKNfHDMpPBSxvj/cXq1iH71ryTxdSRqUIcC9gU+xOy9RFYW7WPkEfs2muGZuC/AxqSwn0/FnoVOx7bCwGcw+lmLzGjE3MXUyTOmLYHLah+YDZJ23oho/XsDx7p9PIuotUtEEMhuX4LT97vw3+D1FmgFRW34v3m9E4dme4X6C3
 KquL2mPL
 K/sRr7vyYgjw/X3llDeZgxMVM5GOC+pMrKuk1swruS86u0SCxBvM04G8wgT3vgooXU1YWx/E8uJyJjgW/sZBUcFqQKCMzneuygpKQZtmok5PqOLcRdwX0ZXUcLRWk19LRxkaMhFkh1yBshdc4X8sSCsnZAO/okcugwkn2POdvYMqR5ItluPZ/w7UevvFtZhIpEnR/nUbo8JWYj6E2+Qo8zTGbXfVZ8/qoYw27d6KsCqsyoa1ilL4UUphjJhb3CIdEbFlZhklgXGQ2vHiZvmu7m1pd2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme region directories by adding kobject_del()
calls.

This issue was discovered [1] by Sashiko, though its analysis was
partially incorrect.

[1] https://lore.kernel.org/20260517205828.6204-1-sj@kernel.org

Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index debf2a3a0d8fc..604b77a47a463 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -334,6 +334,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		damos_sysfs_region_rm_dirs(r);
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
-- 
2.47.3

