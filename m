Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE43606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 19:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=ArQqb01A;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=oQATBypL
Received: by kanga.kvack.org (Postfix)
	id 0C41C6B084E; Tue, 24 Nov 2026 14:37:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075616B084F; Tue, 24 Nov 2026 14:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58B46B0850; Tue, 24 Nov 2026 14:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFE26B084E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:37:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCAA2120C79
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:37:18 +0000 (UTC)
X-FDA: 85471021356.02.45EC68E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5D9AA100002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:37:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ArQqb01A;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=oQATBypL;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795549036;
	b=ep91mrK5jTb0YOcBI2w5L2fZRUgns+nd51oPmDgpPQ+of5qOsZ9znLl2WHsY4SBkasI9Eo
	MUqLeGTCg3zZrtNFr2N/zG23q22GjNRNqoVAYKsIBhQlnQAsB7UbGLMjh9KeUsgMJxCpIU
	J+8sQz1mXY3cQ+ajTSxtUGg3BmnoXDs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795549036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMjgnMOdm5LC9Ve7tJbATj56ZsHM2zVs1s6tMJ9jz2Y=;
	b=kamyoY51TkGuPYISJYMVdEM2TOCHvMCz8/Vm63KuxrdsXYolG9ShoKtbGNJxWhXX0G3gAe
	v2g0iEwdPhZ8/2KXXmW2zxbOvh57G9qNCzTL7+Dj9pVLcb3xzyFEZerJeQ6AIom7CWCqrw
	fvsGfBaU78hNtipCNtbY+6qcZoIOddQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ArQqb01A;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=oQATBypL;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOJYD192439462
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:37:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=OMjg
	nMOdm5LC9Ve7tJbATj56ZsHM2zVs1s6tMJ9jz2Y=; b=ArQqb01Alvqy+ezQ3O+b
	wFGaLKLkRPslDfTTnR/1n3YHEnzFvpSAXsSLtAema3OMBGvQTr8MjsfnQdizF1DR
	Y35c9K1YbdbrokVp6lJBFIYVrUHqLLS3WYYBtEDDKg/6m1bODWncA+LZwiNP1MH8
	Z3bx2LUxG6sfpmxDdUI+/kyZI7guQlRgIUWOBYQ6reZ57nqjYw3JFREOmJXGhsy0
	5UyyJqrfI8VjX2MlX1xqtk46jQix4pqRNZv16i1aL2PIz3aAJytU8fQlN33iF7Uo
	xruvXaD2EFNKvtzNiOaeLj7AUiUNlwagsbKMIv+l5TRcoparlTssaELubPi31AEG
	DQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j5g7bge5f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:37:14 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-536778a8137so87210721cf.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795549034; x=1796153834; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OMjgnMOdm5LC9Ve7tJbATj56ZsHM2zVs1s6tMJ9jz2Y=;
        b=oQATBypL/YfkraqupPpF1u2TdmBdAGkWce6w9IeH8DY6/iDADs7j0EjQxxxY3gPSsO
         Dv2Xw77pFdDnG3pZ0edODG26bB2bmPUvooqCqAPpeUSp5AKpI6e2GQ7nM9eNyeE/vsl+
         1UtMabkKKl8uBPXcK0VZvjMSZD7jTWFLqgtfEHcLc9S8FebvH1Q6l8sDRtUsll/ZiJiU
         mz6IMVu4hNjUvtsuQL2rl8Ni5Ac27YZMXx0oYzR0Zy4AfDE1PGRv2jmFVLLeZFvKh49W
         4N+7LIT8LspCZvPRbU7hhKBZwtf9E2JHYM9u41WUNUqIA8qsoMOzVdt6gd+vNqXDZp+z
         0qSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795549034; x=1796153834;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OMjgnMOdm5LC9Ve7tJbATj56ZsHM2zVs1s6tMJ9jz2Y=;
        b=2JfGtXGirtrm7C1zvfjiLooUQ4ubg+xcvl4kNy3l5pJgwV6VzU37OZPhjUqnPWSI7s
         0eb5jHICaMoPFclqGcczae1VJynemWrcQIYcSoK+g3wzBYg6uwWtzpNQ2YO9RBDbjDYd
         yYmU/6+iyPDyMvdeGPNz6++Qy7OAgccpL8ftAbQZOodHn1cpF1XwWCmNr/qlE/nYln4H
         eh+IT99m/MxeNw1BbWqhhlfxv15oGUIqXQrczmdCkqLb93FboEgAy2Rw0haMdcxOkvJ6
         xmW4E1o6XBDd9bYXvhDSI7WbJuKAAUDPiLEpCr87Per6OUL3n6ZVOU9VnZWbDzkEQ4NR
         /zyg==
X-Gm-Message-State: APuU4Z8/Suon7S/cdZJM5DsMRQgHpLyJokzbOsss5a1+coW4nGJ8kGfa
	suzZkXd6Vh+cIPjFxP9EoZKurttOH9hpMQ9UOEWMK4cf2rby5fOgwf5sZSaPP9osIh5yEFUIscb
	AFoI4utiHKiEE+/dJcwbqg2C6jcLxul7g26sIwMiGRRtyneJ4
X-Gm-Gg: AZFdTZegOcru3vNBETi3ZiBYzyeBLANEykLnp1a+YfT6el515/6N8nkviOVnNTioZt+
	NekRWh5pe5EgErh7bEogIQisWQeAJZqNfZMpAHaH0qCF9J8V2HdQ+/KEKeJS5N7XGGkgTv7RJgb
	4R1N9chkXH9/0WcnlczBBPCmaE3rtgdJyd5U6ee7vIEu+Oh07ABNhUD7oJtVScap99OV/VtmjqS
	ZiffsUTiW3o7MemoWdJq5gVD8ub9OcRVjr6pkf0/BQyEjQZ11bFK9kSDm7QwWKxO/UdR7CCJ0XP
	vHaWZlUa46r/Z/ZURV9sIJlBBqAO5cmTOSGMwWyMoe8XKc6UPGI0PPKzTw7VX1WoqlKZ8NCLVlG
	gzZty2+fcLnl0qjzsFk81VZNo3pqbgmWe7eRuqjnuy7ejIBsu0dyzPpDfbBup5+VJGQ==
X-Received: by 2002:a05:622a:313:b0:55d:1944:a2ab with SMTP id d75a77b69052e-55d76a5af8dmr288718081cf.49.1795549033798;
        Tue, 24 Nov 2026 11:37:13 -0800 (PST)
X-Received: by 2002:a05:622a:313:b0:55d:1944:a2ab with SMTP id d75a77b69052e-55d76a5af8dmr288717631cf.49.1795549033344;
        Tue, 24 Nov 2026 11:37:13 -0800 (PST)
Received: from [10.206.101.158] ([129.236.231.128])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9213515f467sm140631006d6.41.2026.11.24.11.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 11:37:12 -0800 (PST)
Message-ID: <3ebb01ea-fe77-4467-a1de-7f30a91593f3@columbia.edu>
Date: Tue, 24 Nov 2026 14:37:11 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Breno Leitao <leitao@debian.org>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <4f23b0bc-b89a-46c1-b8cd-853e7815b7ac@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <4f23b0bc-b89a-46c1-b8cd-853e7815b7ac@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA3NiBTYWx0ZWRfX/j0G9yEsLSoP
 35wuqZON7QGUM2xy++eiTgpfuS3MOiki2BNe+dX4kV27K6YbyLH4qOVfz6gZVu9XUzBmasekPmK
 pVROeN+hqCEyHNDnOzeH5lNGLr2aR1/UWmqKe8D1RubTJShOu4kilVdnMqjxZpi/vtRhlPtgP/y
 S4mPDE8qTkfZY9tqhTUX3bkAFJEVaES9UDrg8FwGy+GqevkOeI7BWNLpZHNud/4RAiZbSlfFvwy
 pAD9Zoq5kpoRFoaPy1hoZO1t7V56RFhiaB4cAfeADwm+VS33OydNgBkMTF0hbfgBLg4Yt5WU3L6
 M2iv0S/7Z8qz3U5B1yV9r1EvVvN+eGoe0wlILcQ3KWixV/UvtSSn1bZU5voYZlvfIFLD4jR5bIb
 95l6umuvmC/wMxIEPdJw3fPdtDeMkrd65eFaFvAyIgjmohKWjLjtJjcXUzP2uk1lbx+Mg/vS1t5
 5+x6LNQlmN8/DTbX2eA==
X-Proofpoint-ORIG-GUID: 0Y348fM09qJCj4vZOmmvyumLEzcnZr9b
X-Proofpoint-GUID: 0Y348fM09qJCj4vZOmmvyumLEzcnZr9b
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA3NiBTYWx0ZWRfXzhz8z3JVry9q
 3A/dPrmt4mb5T4pvKasijZiVOSieD/LdntkZY7hwX/CfpgxXKqTNDZ8mndSjzSJ0qSACGetKHHf
 RP1i3/Wln1G0m0tkdELOZyqXNN+0+lXj347S5JCTA2qowrn0ec7A
X-Authority-Analysis: v=2.4 cv=RIcmjIi+ c=1 sm=1 tr=0 ts=6b05e76a cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LNQXEAmb7IHcZyFqmLK0PA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=Z7cX3StJxvrjZLnT-lEA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11976
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 impostorscore=10 lowpriorityscore=10 priorityscore=1501 bulkscore=10
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611240076
X-Rspamd-Queue-Id: 5D9AA100002
X-Stat-Signature: 5kkhe9ff871w4byqwt5mi6mkddmhr7eh
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795549036-208409
X-HE-Meta: U2FsdGVkX1/g+43Ur1D9m+gh00EFgJPC7Brgi0Rt/CWVDF6V4Eewfes4lFclktKqnv/5OAvQULKdlUdvezPg8uYKKTT8rx3vzA09UxZz8TCveylDaqLLN/G6hVMZblSinIOLdm/UaWoI/GTq51PqZyLu0kujuExMeMF2LPfArzz1Hyt+uGaTatzDx81PPmbDFujz/3OxlVxNclJoTdDDAai3kIDEp9pW0TRIcb1U086okvnxoso6nMnxExxJP660MHpADa5r0bV4Eib+0mtUusBQ9kDCP4L5vV0HClOkwqKslcfz8uu2/K0u97ngof2xtQN71IR2QLmT0kUlCJVovEfsBwpBCHUSIUKRd5gEe/D02Gsodh585Lp3NjpkVfQf5M599hPI/IJy+etc7g/gHR39lRNOywFBAoiB3utrTk7fsqtS0usZJky9D+YESjgPWfl5tQIMymfQ3IUDUZai6myOOZmJ+0fpOpaTNEQaVl0mqqaIOWafy+NQ9OZTHDfCU/0hZb8uh/aCt3R8xfpUTaLSGX1iNHeNJzKuRmNWnbXoLYENGuq7H7RGWr60G0cgU65zgwSXBO5+kpXeFxkS6MEZ52to65YxPtFcDvArLAv+H7vfAxZEuzc1x2Gb6f6cTg4bH5EqRgqoKWwoqBN4m9jbELbAqOMeT/vMhQ4lKb3oxTF48oNWXl2TYrAX1abdjYHuzXVfSEoskv169ABqdM7G42wfKs574aidBE5g3bl4pHSnVpVVxam9Oqo28QGXmnZQki2/DA3WlVa4H6+KuPQdKklWe4xsFE9ZoURjveBrA6fSWG37ALetGv0M0sYoX5ruzqQuaCvhnGwpB/2maOM+TRxW7aJ7T4fFIW3YTxGMU4uukZwYKV58tRjrQC2EcFCN0RrAdsikCsVQbEgOY+vyxY1fyKGU3i1l0H68QSoRRZWLs57lYTmgM7nIyOAbltQaK43gqJLNSZVwLj2
 gBEN8lPw
 XDSySaAo+rWVjKWwepYlOt/QcUAvoBM/N/mjZex+Eon+Pc0J14lZmwZwNc32njEBpTpydU0JOnDh0AxVv2tIKKU4uzs+X8Z116mo5x83BwspEu/KyqJoOKzVtyGXkXQ4CTPj+S+D07DxUGSsrXQWIDpXMH4GiMfjnEMs9R7NUCH90dIyA3flQxOr1ZQqS2OzFTFrM414peYDvppUJnjvtqBmK3gc6A7ZA1NaOAHFSEeZeUQ38+nZOjcKV1Bfb4aBm2wMT9BzToSroaS4+er0k2zb6MWGnVaiCqm5xQCKVtlHcqQbWdD36hBby1hu7ak7duR/vEZmi6M5hhFCGBcJi3QH8r+a2vkeTPL1/9rrxUwh3E6O8qQXlNZr17ZI7kMsdJHRw2gpK4BgonOibZpORTgMGruMiKe1IiFnBidoaf4o0QcGLNa+PPrZgejvtitlNbdSF4cenOoIlkyxv9isyxHyedEUzgP2MTsB9nmErcUTu5TSWWFY+FsZHAMJ6Nx8mTNwskyr5XgVg3wp9ok5NYqami3jQn2NF6hMRO0XCcfKabgLtcpsbDibhnoNRSuKR93bLEb92pS/mGmv9SWau532uOxe/hAEVkp80A1ZyPjvL0EKgY0y8QlrApDkp9WRgWPoKBsiJRv5KtIwI9rGiCLeNvRfLDanHeEXWF4SMqUdf92WM+55u7arXfEllAjOJEojQEfISbXum4KwQhSvntlTGoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/18/26 4:41 AM, David Hildenbrand (Arm) wrote:
...
> 
> So, I would be picking up ...
> 
>> Tal Zussman (9):
>>       userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
>>       userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
>>       fs/proc/task_mmu: downgrade writable migration entries in PAGEMAP_SCAN write-protect
>>       mm/migrate: warn on a writable migration entry with the uffd bit set
> 
> This
> 
>>       fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
>>       mm/huge_memory: build the moved huge zero PMD from the destination VMA
> 
> This
> 
>>       mm/mremap: resolve uffd state when the context is dropped, not during the move
>>       mm/migrate_device: do not migrate a uffd-protected zero page
> 
> This
> 
>>       mm/userfaultfd: check the hugetlb alignment of every VMA in the pre-scan
> 
> 
> After waiting a bit longer for more review. Andrew can take the rest.
> 
> 

@Andrew, could you pick up the rest of these (everything but 4 and 8)?
I'd like to send the next batch of uffd fixes I have on top of these.

Thanks,
Tal


