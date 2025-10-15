Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3745CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526B48E0015; Wed, 15 Oct 2025 04:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6AC8E0002; Wed, 15 Oct 2025 04:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5C38E0015; Wed, 15 Oct 2025 04:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2757C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:43:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C78A7C0B81
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:43:38 +0000 (UTC)
X-FDA: 83999710116.16.D0BBF74
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9076E40005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:43:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AiXi17l7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of dalalitamar@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=dalalitamar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760517816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Cxf53tuYiU+Dv+DHgj1lSI5Z/XUbb+V/oDZLK5mtN/g=;
	b=hAqPmfjDXnpFmIL/ESeN7HTSyn7B3H1zOEgfAp8b3WjQ2QJmHdnAoW5wto3kRrOMETtQGD
	vKYmRghXjc5bavh6nCSHa2FV6NHh2pONZWIVF6xIlv47Cn6cLSrOMESe4kqEmTyTlHteJp
	WaO2CMcSCuMwZ3eumLTrnxKnk8bb4/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760517816; a=rsa-sha256;
	cv=none;
	b=0rVfd/dSYUspMMKWo6xM7rPBzFzSLY4S4R7dBwKoVQWGmtAwe45x3snffi3hSI5PImpX1E
	T/BuDI3rZ7P4XO0pp4z/zKTLYRmsgW52LjUC3L2iXSdVKUSjUUYKCbiUG0jsBpAAa0uHMI
	7O33LJaLYzs+I/SP9smidsjaoq/gWj8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AiXi17l7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of dalalitamar@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=dalalitamar@gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-650512d88c0so97305eaf.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760517815; x=1761122615; darn=kvack.org;
        h=mime-version:content-transfer-encoding:msip_labels:content-language
         :accept-language:message-id:date:thread-index:thread-topic:subject
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cxf53tuYiU+Dv+DHgj1lSI5Z/XUbb+V/oDZLK5mtN/g=;
        b=AiXi17l7kifgOBwrXewZNUxBsA79i4lTDS+Nb+hxNDyYL9NrfONzwRRwtEiIvHXiTj
         7ZLrl4VNO/42SvImj+9suSPBdxBFA80kqhQWHMcR8H7+J6GfqASEiTPfb61QAnTAtswB
         pG7SRrNJpMs8fLT9Q6LeZcxBCIuxXATVBosaPMNv8SkEpo8vXa1n7dQsjDGcVNngTlc9
         +Iz41w6SgSdlBNMIxlaBZquro31sfBtmr+9r180c1FLOqgvhH2FkYt4LdrFIS3c+DXjM
         qzCDnfRnn3zRST00g7A8QeNtUUHE5VyjURjneiWf4/4h8RciqMc8aXpa0dYtKrDAD+QU
         D8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760517815; x=1761122615;
        h=mime-version:content-transfer-encoding:msip_labels:content-language
         :accept-language:message-id:date:thread-index:thread-topic:subject
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cxf53tuYiU+Dv+DHgj1lSI5Z/XUbb+V/oDZLK5mtN/g=;
        b=OPvsfj2sbHdax9oyvDkCmZb1EPrTbqkzeQ5jSGxkv+nmuAnOkA+P6TVwB+YI5TcRWf
         NeHkTqkTa5gKjuVzfC9n1aCqDGrcPWOFt/B+rt3qQIwQ7pQTt61WAIiVNeKnJty0X2D+
         Tm6bHF25fbyOy/WUCCMpVmGX4G/ilwBZi3yEQ4UmyBg7xrZFid1iNFddL1uApk6LzY6W
         7zUlLrYAJNesTMvIFg/3guIl1paA2+cuKwAKXkbaLqZjzC0caOcvm6oqEw7bgYZ+QBhg
         0Ee7LFtwx6vDzmXbnLa5TN8f/+YGOqvJihUXi/Z2XDSaip6R40Aome0nr35OceXmbVOj
         A18w==
X-Gm-Message-State: AOJu0Yzz/RueyzW/gATq6yQ1rlVuCN0xkKace+PTohgX/L7HdAxPIFNs
	vhK/q906fsitRyCAY/9x0Kb3874RorcNEltYsPOOcEk7qVfsHB6beTPz1GiPIV+v
X-Gm-Gg: ASbGnctbZQpLs4bR4kFhTaMfVDSDmb0RI09Wv8aEK+vHJ4x87MJB8dOgwNZzkCEluw8
	Ua0Ps7zvpctnD6yhyhFI/LygXkCg6vsXx1KulTlfwMrpaZswfwG5vlI5s8ukf5LqAZ7obiIqExG
	32cwKr+JUKPiVgCDiprEz2j+wRoexz6KYKrfQ8HDuZ/mKKWR/KOAIaEpa0vzOXq9cZP0Xzq7Poq
	smTULMSd1hG8/fr7mbRVo/UrDepTM9HMmCknqho3N5XjDfJt17BE3SznqvTLKhujZ7PiKwU59dq
	HhLMlFw6zZ72+KQcgVtfnLxxzGwLyYUsQIBfnLwBfQIVGTpXeLAU3kvkRpgWtvzjihDc8nL+DpR
	uJHkEh4j9n5L7O7yrPGfgQslrDEKAP2MLQxk467brX59X9qYfFr4HHGTwaBoOQ8gbZrJY7uNd5v
	//G9WGbAcU9MUAvgU5QK8Oo2hB6Kh10vcEpFyE
X-Google-Smtp-Source: AGHT+IEW6YfwO2Hw5oVjmZcWhTT2ZwRVCeYlsQeMytKJhVKsXPe7o8q2gMr9wQUGjacZjGQXxV3gTg==
X-Received: by 2002:a05:6870:d8d4:b0:315:663f:4056 with SMTP id 586e51a60fabf-3c0f5d13930mr13019224fac.4.1760517815138;
        Wed, 15 Oct 2025 01:43:35 -0700 (PDT)
Received: from SN6PR04MB4048.namprd04.prod.outlook.com ([2603:1036:805:3e::5])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3c8c8ae8f91sm5234410fac.2.2025.10.15.01.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 01:43:34 -0700 (PDT)
From: Itamar Dalal <dalalitamar@gmail.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "riel@surriel.com" <riel@surriel.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "harry.yoo@oracle.com" <harry.yoo@oracle.com>,
	"jannh@google.com" <jannh@google.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"shuah@kernel.org" <shuah@kernel.org>
Subject: selftests/mm/rmap: verify correct RMAP handling of COW pages after
 fork()
Thread-Topic: selftests/mm/rmap: verify correct RMAP handling of COW pages
 after fork()
Thread-Index: AQHcPa+FfLpoUZg/p0aSBo0MKrxelg==
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Wed, 15 Oct 2025 08:43:33 +0000
Message-ID:
	<SN6PR04MB4048CF9A242A640B29A588EDFEE8A@SN6PR04MB4048.namprd04.prod.outlook.com>
Accept-Language: en-US, he-IL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
msip_labels:
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 9076E40005
X-Rspamd-Server: rspam02
X-Stat-Signature: ffzs7z84x3yjuuk91khyesuxm6nhfajo
X-HE-Tag: 1760517816-768066
X-HE-Meta: U2FsdGVkX1+pDn2zEK9JGjUYAnONV43SjdyD8jywNtzN0sp6aGsEYl/k9xbUrMvzvHdADWpNnmbIgVG2++Z33NXcoZ0wFTu16zeZwGdeTMt3OysfSj6abfLXIXD4m874HzDB/LHglslEUWgRumAGn2XEUDTrn5umab4ksWNuLewCxufz7Wge01ekW6kqM5OMBgzx86uuXILL1sJbXQYaIKVYaD3AMNESLcFV1/XI3Pi0Yo9MUelO5obzOBbYGo9f4cOJOhSWTgtX56jv/ACJoaqtt981ZzhKKGqMBj7AzbDLAUbuZnaSQ8xyhHIKthKKj8NJwz7S1RszVpKL5RBNbIDN+XxcyqPeGLgD3EG6JBlZQznC1C95bR/n39ZAMRD8tX5KULmXnWCUmNOxZLGDanx699DGrn5h66OrfPvty1M9zCFOY+TTJU0jJ/Po9wgPKbBFL9cbg+ZurAPXNV0fkDGc/jDKib0TNYt/Gt+TUfXhh8XbP/HK2xdpr/djIzYfEd7Wv00LXBaKpjoxco8p6m3eanlf6kRJZC8AzBQiYaHUMXFf4fKILgnlApvRYzNKqk7+rQAHcqAur5tY3xbe6ma63EadhqMUbRAj86S8Korh/BpamrV0Op+j0NhKzQz/hAkfUNrxZ4OaNKNU6uKj76xb15U/E+rgH5vUd47tX/i7DtAVaHXUmtHQ59HzpRWR6XLkGLtGlBW0qxmJDw/ZnhLVfmxGm8RnB1CL0lRpS6ICc252s6O3+Y5x9XnDv+iIRCDGoGE1cudRoUptdYfobxSX6bjH1osLafzSf5s5a9S/hB85T4ISnmP0Ac1dj2rQ/7npbmh6Kor0MH9Lnc6r8vS3/R6qMNPbmqcU9k3uW3jmZB8Q1C5nWdYNalEVSjI6plduaykzPaqba9XhcMVfzDkilYrPNBtb2BAQI+/jpCZHsCVnpr6tD55imD6uI/65JcX4fY1kmoyM4B4QGiU
 gWGxrJ9G
 GPiYGmHmv4OLv+4kQSfN/IW1BlOosZ6TdLsqP8dCdJ3LKuvc3ZE4ZvpcEKcfjLHBmTmt7NZlkSov57bC9cvQnPR7gedKwS265VV5evDxb3efA6ML2NQ6ZzLs4hbUuyFvb0V7DWr9fTLoknCWAW6DxfKwTC8w3RUXb8vg401thKxGGKFM7dGZkjNN9rPgK8j+gy9VHS47BExjtVwV/2zqOqICacxMsSgtnIs3h8ZGjWaKATVEIDapdkH39ohyWZf7l67dWNtm01aAskQj1+1ZWJnYp3nQ6aF+F+cDLilfG0jY0YQ7f7Pp20GJFL5uu+rSlDWCKVhlfm8p51QUUm3Ij0byF+SNnUMIvgmua4+0o9YT8tlWzPCeY4Xi9AUQ/ggl3IDR13bpwtzwOkvlFoQ9V7yNnly/A96LSsvnfQGl/bkKGxwjUsuKSdKjWRcT8LjzaHjYwEPHw6Npu0UXP+q4hPodo3+YsZ+wz5WC/1Vqf+WJmuGeXLV8loJgZgOXOtE+4JLiorRosMa72mW4uFYOb+OyBt68RYZ2abt4oRqxFn/ExwHj/EBI+apibtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new test `migrate.cow_after_fork` that verifies correct RMAP handling=
=0A=
of Copy-On-Write (COW) pages after fork().=0A=
=0A=
Before a write, the parent and child share the same PFN. After a write, the=
=0A=
child=92s PFN differs. This confirms that proper COW duplication occurred a=
nd=0A=
that RMAP correctly tracks page ownership transitions during COW events.=0A=
=0A=
Signed-off-by: Itamar-Dalal <dalalitamar@gmail.com>=0A=
---=0A=
 tools/testing/selftests/mm/rmap.c | 45 ++++++++++++++++++++++++++++++-=0A=
 1 file changed, 44 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm=
/rmap.c=0A=
index 13f7bccfd0a9..2ba3361fecf0 100644=0A=
--- a/tools/testing/selftests/mm/rmap.c=0A=
+++ b/tools/testing/selftests/mm/rmap.c=0A=
@@ -430,4 +430,47 @@ TEST_F(migrate, ksm)=0A=
        propagate_children(_metadata, data);=0A=
 }=0A=
=0A=
-TEST_HARNESS_MAIN=0A=
+TEST_F(migrate, cow_after_fork)=0A=
+{=0A=
+       struct global_data *data =3D &self->data;=0A=
+       int status;=0A=
+       pid_t pid;=0A=
+       unsigned long parent_pfn, child_pfn;=0A=
+       int pagemap_fd;=0A=
+       char *region;=0A=
+=0A=
+       /* Map private anonymous memory and fault it in */=0A=
+       region =3D mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,=0A=
+               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);=0A=
+       ASSERT_NE(region, MAP_FAILED);=0A=
+       memset(region, 0xaa, data->mapsize);=0A=
+=0A=
+       pagemap_fd =3D open("/proc/self/pagemap", O_RDONLY);=0A=
+       ASSERT_NE(pagemap_fd, -1);=0A=
+       parent_pfn =3D pagemap_get_pfn(pagemap_fd, region);=0A=
+       close(pagemap_fd);=0A=
+=0A=
+       pid =3D fork();=0A=
+       ASSERT_NE(pid, -1);=0A=
+=0A=
+       if (pid =3D=3D 0) {=0A=
+               /* Child: write to trigger COW */=0A=
+               region[0] =3D 0xbb;=0A=
+=0A=
+               pagemap_fd =3D open("/proc/self/pagemap", O_RDONLY);=0A=
+               ASSERT_NE(pagemap_fd, -1);=0A=
+               child_pfn =3D pagemap_get_pfn(pagemap_fd, region);=0A=
+               close(pagemap_fd);=0A=
+=0A=
+               /* Expect PFN to differ after write (COW happened) */=0A=
+               if (child_pfn =3D=3D parent_pfn)=0A=
+                       _exit(FAIL_ON_CHECK);=0A=
+               _exit(0);=0A=
+       }=0A=
+=0A=
+       waitpid(pid, &status, 0);=0A=
+       ASSERT_EQ(WEXITSTATUS(status), 0);=0A=
+       munmap(region, data->mapsize);=0A=
+}=0A=
+=0A=
+TEST_HARNESS_MAIN=0A=
\ No newline at end of file=0A=
--=0A=
2.34.1=

