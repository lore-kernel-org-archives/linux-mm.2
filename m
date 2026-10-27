Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA0F3606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=Nt6KpMmo
Received: by kanga.kvack.org (Postfix)
	id 7D7B96B08A1; Tue, 27 Oct 2026 15:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7884F6B08A3; Tue, 27 Oct 2026 15:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E356B08A4; Tue, 27 Oct 2026 15:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4C16B08A1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:02:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90F1A140AAE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:02:58 +0000 (UTC)
X-FDA: 85369328436.04.A9CBD1B
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id ABC031A0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:02:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Nt6KpMmo;
	spf=pass (imf19.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793127777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1jtA5ybr8vFxqljpK300PDPycf6HryqQqX763TrmniE=;
	b=Gdf3u5lOumHbk2O4LvrhfaFDuE3bnI0gHZnvTiaYMV2Sxs/WKMMaWLOuhRs/QTDbqOs0Qh
	HS9v/tIOW6F1nF+qwJ4kfXQE9kE1T9MbnnLjBC6J0iQrmHBvlKJxhOlpX8xR6OiO31syJK
	oUOce13qgLWzUQXfUZqQHLt/FUJD3oA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793127777;
	b=YS1PRc2XhI/Hviprdxm9mTYJCnF2KrmJnJSfYZRG/n3RfiUy9cpKwRMYK5XuZusJf40M9y
	myc7bhyi6Dw9IhUQnH2BOMDeGXNlFqUXzL5Xjb0y7CdM2m6E5JFoXIkRIUhYKbJRkT80Vs
	+0MicwonCgZJMD0vb7zRk9ahIBkbHmA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Nt6KpMmo;
	spf=pass (imf19.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4jDfyM4cmKzMkr0;
	Tue, 27 Oct 2026 20:02:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793127771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1jtA5ybr8vFxqljpK300PDPycf6HryqQqX763TrmniE=;
	b=Nt6KpMmot4zqA3t1yOECOI7SB5/sV4SAONLx758SqvyYG61B9XsZnK2eSKuGsLhy+ApIYv
	Hy7cx4hqmrpLgYGBbE42Z7dwIKm8p/WfGnB4a3RpTbKw1YYJsAyrTyJ0LKJtPjkt2Di0Jh
	bYoFDMWTVY2bSe842g+3YLukT8NxZlSAVcwAUBCAlI/Mx3eei5+KOLu71s4bZrejr+I8yr
	DNPyJQn8luYhVsbyLsKRYaLVqfQfQRG/ufMmPjzWYgcxJmPpn0kR5sxHrxsCBH/cnqGZbA
	kWn6Kshk1uZddkRl4+G6zrdjQwqDu9PHuZcyACSj+h2N0pnQbYt4dBUUYhf9og==
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	Aveline Noir <jm5905938@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Docs/admin-guide/mm/damon/reclaim: improve language 
Date: Tue, 27 Oct 2026 19:59:38 +0100
Message-ID: <20261027185938.2526259-2-manuelebnerli@mailbox.org>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 165968dc3b9658f2d5e
X-MBO-RS-META: ekir4kjfqi65edx5rn14zxbd1xffynbs
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABC031A0002
X-Stat-Signature: t4ix1bupy1su61cu4nfq5mk7rigsxspk
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793127776-448141
X-HE-Meta: U2FsdGVkX1/kSL47IGrnDIPPCsEx0+NVgAXqI7O4GV+/ye53SencK7MqaK/n8FJqThkEuywu+h+WZkE8Y5/Vnr7u/u/ATnhBN2qJTpY/LZTNDujF8a9TnjyB3QTvQRwA2+uX07lUQZLihuoNvMdq2V9/HnFeIkHJnM8+9UU0gWkzmBW5ovNe3yTXJIFGE/SI2DwUCTZYlUH/otY4uOKwXq5MNYC0tAWKzZ9zpkhdPYKFpyRjQXNbNTAtxW0ODRP45XpSa8LiW/MEHcnyZsHmEicaiiIAKJvMiMhiFJmzar9UCjPDgepGaz+aX2+FEUU/cdfLh5DCcaLwCIUFl22MnvkDcKyixX9OX4EqzOhvVhKSYHef2lES97PiU1/J1EzfzbSi7KOgokLr7y7uOgiJLF6tNMrlawbQCBffTfuY1yUGRUZOGZo7YO+Qfgu0a2SfpXinQtCiawtBRcsu0Rp8L8qXBfOOryugiv/GOzKwFI8EE3O4GGeL7ZDXDOtmhm4emYjwsuxodVUHLDMim0PsjXmilLMHtVogevJtzbufHQYjxfrBV+SzPdX8jR19hyZFXk8Zegpn9kr/GOrIstBthd2pXZqrbeQUThRMTmhRRFZV+/LlVntZmSduFa2F22HUuY4b9MJyQvBcZ78CV2YG1deDNjEKsBAgWCbqKkD9vevu4GF+ZpaARQzZOL0ZeH6BWi7QhtWH7OQ5VaQaV/0Hv2wErDSAGX6lgv/4OsOCoNSWG3fRE+OiU6T+6xLzvR9Si18v+Y7tSuDH3yBKQILqRr5fPDvgIk4RQ/F5hoaO4wxeGDnG/DQa9+FWzu+pRL45IaKuQ4rxiiPNt56u4Rgop/XoP8n+pC+TLcUbtwi9oDUFc++bvTR47AMuylkd3YpSZLnDxSi1VGXQllmmMfVEYYbQVw9jWk5XR1++l2ZAHhKJ/qbaBqDhgtSfPvKj7dhDdOSXkCKMkiD1y/rtGoy
 qZuFRO27
 qzr/Df3GFuqs3X9otwF9/4S72eL8AusCKp1+XbjzxK7aQcp9D7gP/Q3/j7O7qxiDM1cbtxHzHK2s1CNATXuPoeKcnw+1OPww35+H4A7OI2h4SbghDeXUDeRfXkPFQGr5m5XTWv20N4TipC6huzMelgAcZxKIkr9keIVgUlRzCcpscFyzJEAIiGgGqo6FZAu990LvMZsCPhWoDQYGpcmyIE3AQSDjZT2uWntizqU9WERa+3bIanJh1cvZi20Y4UfqFl4sQ5dG7Rcaq9lXTJJD1d+Er/G54EbNHjBy0H3saj77l/H6AwAtw9VZvOFD0blgLCjptSjr/CAthgFUWCX/n17mIUHPuyX9GQLVLc1xWu2oAsGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I went through the mails and divided the diffs and suggestions into
two patches. That's why some changes of [PATCH 1] get deleted or
written over in [PATCH 2].

I keept lines with barely over 80 chars and didn't fix wrong upper-case
in headings. I prefer uppercase Nouns(sic).

@SJ
I hope I got everything. If you have the urge to change or add anything
feel free to do so.

[v2]
 Include suggestions from SJ and Aveline
 Split [v1] into
  [1/2 v2] Docs/admin-guide/mm/damon/reclaim: improve grammar and style
  [2/2 v2] Docs/admin-guide/mm/damon/reclaim: rewrite complex parts
 Fixed an upper case and a missing double space -> [1/2 v2]

[v1]
 https://lore.kernel.org/all/20261015080623.808458-2-manuelebnerli@mailbox.org/

