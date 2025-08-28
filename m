Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69AC5CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417FE8E000D; Thu, 28 Aug 2025 05:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3536D8E0001; Thu, 28 Aug 2025 05:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B898E000D; Thu, 28 Aug 2025 05:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CAF78E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF1EA14069E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:39 +0000 (UTC)
X-FDA: 83825668878.14.0CDFEFF
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E86E140002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=l1DbCGhd;
	spf=pass (imf23.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqGptO2eIB/qYhTXbL0ZOcw76oucCT92viU83AkSH8I=;
	b=SA8o7rL0gB9PJKDCqg2cQKFy528pWjIfoHOUAAW7z8jvEj/rIGQ0pY4M08KgE7dy4H5jdh
	R3yMpBWuW8t2G/HIasjt8nZ9IMKH4ZVdlMJG20y0tLCsU8Y9N0YAcnx1NByIi9MQKbe+p4
	nYqpb6+nHagTAeLbh6EerK1i6XKrIlc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=l1DbCGhd;
	spf=pass (imf23.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373977; a=rsa-sha256;
	cv=none;
	b=r9mpOoTi0KzKW4pmtwiWR3b6jK/PTpnRyI9wV8IsyEeDTyC5iesx3hNc7atN6gTbuss+1c
	yD95OodkrmktfuqDTzUlrV+zYMM74kCyChb3hZx/RMaHKWYRIROwlH0SSH6S8mYzqYtxbn
	oGChJaySSg+y4RA0xKY9WJqZVvjVBnU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373977; x=1787909977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VqGptO2eIB/qYhTXbL0ZOcw76oucCT92viU83AkSH8I=;
  b=l1DbCGhdDzLAwXEH6c2ZL4NEQA5HH5TeAKrNAh8PN8YxJMfPTOoSnFLk
   c7fMF3rBMfN5DKSKw0uxfe/nLTAl5/yRNEoMnVAkGU9J3uStI0whFI2It
   2wcG2bomBkGafI2IzBZtZ6W8gKmyKIoudGp02LbldvK/HF2/Bf1YTFNqC
   jMQu8Tapwny31rUi23S7E1AYQ8u7n+u/kj3+Rwucevd08etKJzoHAv8hc
   1OGM5Hl1PeyI4JAbd8L7q2bQ0/wWgtQq0VvWKI69MhlWnmKs27tHU0h/j
   O7PwoS0ZLdIbLse3sbq3srU06AoKQPy3BV2Tb0htAt8MV4Eb37eqQTP7g
   g==;
X-CSE-ConnectionGUID: XkXzBx06QR6nJzl0Yj+R6Q==
X-CSE-MsgGUID: YW4iRhH6SrWZheQA5BAZZg==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303839"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:32 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:30618]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.219:2525] with esmtp (Farcaster)
 id 30bc251c-cc0a-4eef-b700-3ade75b8cf88; Thu, 28 Aug 2025 09:39:32 +0000 (UTC)
X-Farcaster-Flow-ID: 30bc251c-cc0a-4eef-b700-3ade75b8cf88
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:31 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:30 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:30 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 11/12] KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP
 in guest_memfd_test.c
Thread-Topic: [PATCH v5 11/12] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in guest_memfd_test.c
Thread-Index: AQHcF/+npK+gu2tkp0adAvgbddQ75w==
Date: Thu, 28 Aug 2025 09:39:30 +0000
Message-ID: <20250828093902.2719-12-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: 3iapcp1wz9uk1ggikm619ge6p9wsybiu
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E86E140002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756373977-159122
X-HE-Meta: U2FsdGVkX1+zrIEQynE9AFNvvjCDUe9K2EJjjbaC5YYe2eigCYeGT+AGlfa3dG7/ouro2tycB5lWZ2rzEUW5EMgkPpKF3qL3jQUi4x5CvtHQbaA3opI9sW86/FwX6RZdGRY3gk+5uVObo+pFU+j8gVK8P0DkLlhE+Lz9P/+YuO5xm5TFApEOla1Spu1xne32MvebvesUUmMBjNCnmCDLFPyXrZylSRQvRusZ1R6Ge5/KNcHZh0UMeVvojda6NkOn+/XJYw7kJgF6KuoG73OHHE/O0ljMdQj81yySwZga6Cq15xiO8Un9me3eI+YW0A8tgXVF9nCSh41HZOvF2aP0JvMaXhNLH+ynZPrXuzM7bEafWKI8Y1qHQBQWQ2yQxc+EHmuVHzNkiUttfVP6ErXuuRf8eA5EuZUpIeM0SrTFOlq3tnAqA9WBNtooWvswucjR5OdLGEB5Uy46HTcl4GeAMIauZesvsy/pzEMo27KmMrYCjMqDaogsTKUNPsp3adVqqK1gjZX8RC5ZOB8UCM6zRI0J/BlqhbEPQGxwt3pMrpYG/4rXBzi8KMlqngQAUNnIvAGfMRuTEHWj6iJE6waKITVZ3LaIuAw5B3sNYlOP4GMa6cb0CcoYT7SjnuL3PxR34aT00v64eHQvl6uthQSKbP2WPqzjKHBEgwIOeV5GciLRDsb8WQlnufd0MexrUpAB7ZqB0YHCqH2INXS4LsPhg5kOryMuPDuq5P/N/lR3gZMI3CHfbNPfNuNhS+uZNt20MclNom16XicrRwZnHy9L18K8fB/0JUmSI7muXhZf/h4EsvTYIhsIOCq4EDY6EvQd8FP1LmyIM/wLEugjTvR/fZYIukns8Txo3rxvTqgrDl7TEu9LKrjcwC/9N3D4zdbnyPMsRNpdrlf/3TINXPzfa+ODqLikWKPXrgHZdTmf2BJeHfTDdNr/wPUQudDTplGOOY8zyHPR1vdJF5PBL00
 Kb/aGCh9
 Flb2hpo+i5io7z8t3HsiHCGGSBsOdmO4LtLQWEnwhoe293w48Qid6X1y7PN2DEVlBkDA/Dmd5avfIgV+QEljbpIhr0PGNM9siXvbdaIjcQFGXltID4VHNCQV5znub3oBft0DwzStZr/pZbQxmo+6fdvueps3D0lyjQizS8YeE5jskJ6gofxzItx+4TscpXkudwyIlkSH16mGPnodOuylcADTldou42RfMvok+KtgIi0GPkZ5sVUbAgSpYswG9Xs4NsB6h+PB8clYMyCCE8/46tkzxFDnt/OeAjnCU6gH5HnadT1zxmH1tswY3SGfFr4W8cMR/l4hDcI8pXsILm8eI8VMeLhSXlaOC1HNdL+upIboswRTENoDLlKREGc5U9Dylc38Bhq9DeMKANokDQ00Riv2QBqRbdt9VhLtBF49inU2VCx1gUsWRookw0SzCLWV+dDJ9IUjORb7x+m+MdD1wBpurDQChltB66g4hxtPjb++zeN2ERlSsSdRet7Wa7ZMkMG3OCJbPY1tsUKOLTK41HHCEE0m2yAoKuSjJpWY259EYpy85KHZUQfInoHZp21lWVsiPs2ZUAx8AXIEscqmgh/tFngUHAxH85ErM6KTNbEYxOvXQ8WfccZEXZAeNSq1VS0U7veqfY5UC4MFKrw7haBsrHe0yP7u5UIJgXt6VqfeKUIRV51VonjRWAuzeWq7tBUvPQSkrVrFJFICWD4I9Bojm/piSLYCEVEuI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 tools/testing/selftests/kvm/guest_memfd_test.c | 2 ++=0A=
 1 file changed, 2 insertions(+)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c=0A=
index b3ca6737f304..1187438b6831 100644=0A=
--- a/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
@@ -275,6 +275,8 @@ static void test_guest_memfd(unsigned long vm_type)=0A=
 =0A=
 	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))=0A=
 		flags |=3D GUEST_MEMFD_FLAG_MMAP;=0A=
+	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP))=0A=
+		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
 =0A=
 	test_create_guest_memfd_multiple(vm);=0A=
 	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);=0A=
-- =0A=
2.50.1=0A=
=0A=

