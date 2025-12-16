Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEC0D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808C46B0005; Tue, 16 Dec 2025 02:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B30E6B0089; Tue, 16 Dec 2025 02:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2A86B008A; Tue, 16 Dec 2025 02:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1BC6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:40:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E61CB60339
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:40:28 +0000 (UTC)
X-FDA: 84224536536.05.9154127
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B4444000D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:40:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pJG3cS1A;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765870827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KLlnYSAyzL/zQdkoj2AjgFdZbBPkMmF8/aMrvQyJIo=;
	b=KRb5g7Fhg/OnlPt2m+vj39anHyKW9EJ9Z5Jg4nMi+qqMQo5Dz+YzhqfoUrTCawQGRdzmWE
	hnpU2CGwuUEy6wAFfUhnRgju3PN8zcXSgdAyMKwOSoLsc70JAb644+GKrgnJqL/GZ82rNG
	nkhQx5yGEV2ah/BuA85gntzvW/2fZEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765870827; a=rsa-sha256;
	cv=none;
	b=bloza5Mecf++5lTziS80lCaAd3iWdpsXSB2ohRYyZb3+qS7wEDsdj5v5VzZK++BtjC0wSR
	sJ6Rk+T1Tdw5TJczJp/siVRpaZbQywoonT25keuSss7lZ2Zdg3eXlWfUtGAVo+R0d9GGZ+
	qZmI6y94SWiS555UT1zUhYtJ/2QX82c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pJG3cS1A;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765870822; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6KLlnYSAyzL/zQdkoj2AjgFdZbBPkMmF8/aMrvQyJIo=;
	b=pJG3cS1AuEHHs9t8k5JBdUzOEszApeQGQrOSe2CNI9CZCUXYOKZ6bv/FhIb7Zj0bfVVKuzS1i4ErZiG9AeJIld8BmpZZQ9ynGW0Kwzj1/6HGkXYTatNam/QdnKZRE0tlfltjpLf0Zryso2RHP+bbEUXJD8y8SvYIla5z2S58aAg=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuyJPSE_1765870820 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 15:40:21 +0800
Message-ID: <906400b9-4594-4176-9fda-7f04d55d8aa4@linux.alibaba.com>
Date: Tue, 16 Dec 2025 15:40:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] docs: tmpfs: remove implementation detail reference
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1765833318.git.luizcap@redhat.com>
 <6c611c5a46548039e714cda6014d47c9d93fcbb2.1765833318.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <6c611c5a46548039e714cda6014d47c9d93fcbb2.1765833318.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h6o7ma3a4k6qr3z89fi5zf91r13qyufy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B4444000D
X-Rspam-User: 
X-HE-Tag: 1765870825-790321
X-HE-Meta: U2FsdGVkX1/7L0HtG03I60EcHtOQEIxuUSMtWA4yfgtmJgsMhlIOm8+oIvVaanKpEQvZd3m3FTOohA+/SnPtEjHuD+XdQMbTVLHlRK2QIOvuwH7K6SJ9GI5HOIEvLg0MIhzoZRZiSDVeXcguIXZi1mrQgSm0ayP55hZIlymKxfqmMpeEoKs9UwBSartv30YAj/gw7P5EktioB9Bzcl6ya8V5n/C/SHTx+Bl1mtN5N7iUJkTcY+3vPUzIQAH6cYMd72N6WYgHqF/POX+Yt06R0Q1GpS3hM9gztPOiSfJinJ27Zwb5/Y92zUlczHuTUuMR5EcHOh/vLwOTBK0fRRHfNuQVPwqC9hCVLZalNkWoN6AB8FGN4a0gM/hbuxBqRUMPHjm/iAx5CIie4l6DSaOXddct91AFv5MZFVw1LJWZzqmlrAnAlD/aeSlcpcmnq6J1qHJ4bUoyaZzVjilv4REcYH9T0Y38daWLmNTcUnzlQJIXUYq2soCjltN6Fk1ioEoV/1Bzv8HaXk/LxoaiawKeqMl7VGp/wAfQPmyvSC1zD1fj3V3AfKqUl081bg0Czfo9QIeIaCq9CPoneXkGEZg6tx2TIyWBjn3icKxNZkTCxkJuu6oxhz16Z9Q+vnxLjhc4hcLGnGcKgPxt8RKuvULuZNKI0c9+kvsbU4o+oZHY9TcdMvb2YoPcEQMq/kBZCgvy4DVtHQrdq2m6aboMcuxvf9RISdHjkrZFUntJapjH8bnsFzb/L2x/9l7YoT2JHy0baj81qSVGAwsERTWaKMPS3mOiPcqL0AeTfleOJNtjtJI7casNOW6ZhidBHmfDg7Tqe2McN0qldrDiE1JgTIes7NksNIlxyQK+rUWKqlt3z4axzu+Cqx42ZkpZJ5vfYRjvzIVvxhOjvG8dUuVX4CshDBMug3MCqFfLuhtzmgc95nXbrEY+orJzRycYPLKos+2NAAXF3nfEuMYviDbDUIg
 PJaUBsS8
 Z+NBnwFadaJabV8Jh6rmZyu1dysLdm86Kvc3r9gb6g5SJQhfYnF+D1Rf0Z40cEwdIirXewDLS/39bn4a8XHPbPzlvDNydv5TJV/sPrXZLxNphFbPuWvQADVQ01pHQ4ObcciIvOY8kXZxNOChCfG3tZranaYcdHXLnY09H/ggG8RJHpKqeMxhmOWpgVLWap46XOmU2BwAh5hfeaB6Su1r/ETNBqHQkbgN4Tc6329IgZ7xpzNv8xhOFIhH/NaIiYud5Z04ON4DNlyMh8FC5KXouhUa+pKqTnDCyHc3wGtXyvofyXlNi5vi5Jb9NGGSbkFprZnamKrFvppxQ5JP7khqzGtU+7tW+Idsq7QJg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 05:16, Luiz Capitulino wrote:
> The tmpfs.rst doc references the has_transparent_hugepage() helper, which
> is an implementation detail in the kernel and not relevant for users
> wishing to properly configure THP support for tmpfs. Remove it.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

