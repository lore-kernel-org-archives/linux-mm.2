Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33135606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GD03ukNX
Received: by kanga.kvack.org (Postfix)
	id 527EB6B05B1; Mon,  9 Nov 2026 00:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8AC6B05B4; Mon,  9 Nov 2026 00:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6846B05B5; Mon,  9 Nov 2026 00:03:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 205E56B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:03:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C5F380521
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:03:33 +0000 (UTC)
X-FDA: 85414387506.17.7B2D628
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 127A0180003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:03:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD03ukNX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794200612;
	b=nct1FQl64y2uNdPSwIUxD9cnGKETY0IcOlPdHks57RaKOMDygo9jI0U2AARA7AGbpgwD+I
	ufYLSSAfigvSiY+/o9XD9Fqoih64wvRMsa8wclRDLAY9Smf5Q47OpAqPwsox0SWf6JStmO
	PvpIJuljzi2gX67HGJkUoRjKeWUFmOA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794200612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKDYdtIPpXv/RzXHp6m0fnJtTmWjQH/piwGs13om7po=;
	b=NwR557RR8axC5+22I5evUEoQEWKtq31Ipf/FSsZIbSZhamSh0DD/Z8OU2PPF/fCMkFDmYd
	TTT9QRthlAUeTXEexPDmIhNMG9DMfk0obvMUwlz+z0PlikJDfqqggIckLLsrx7mSx3qe/x
	RV0F5QQpYCpvL2uqO7ZGWqOPoOinC0k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD03ukNX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DE0260D76;
	Mon,  9 Nov 2026 05:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4746B1F0089F;
	Mon,  9 Nov 2026 05:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794200611;
	bh=WKDYdtIPpXv/RzXHp6m0fnJtTmWjQH/piwGs13om7po=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=GD03ukNX3qpJy/ulw8mljNcuZ+ffE/s+zMEiPrDEJKEQ+cye+2q2ws/q05r9C/MwA
	 8lK5saBohFqhyS1SyDBT7NAkEwD8aM3vrlD9P4LPvGRgDSSGrGefVUdGFsWkIN+fho
	 KpZxXNBbAQhXwg6sB5B8D8Vm59TczWTrD2qm7awrv0ZfpqU3B5VLjxjl7H1AjqQp4S
	 i75YS8Qrd7Vyem4PeyW90tc16A0bzx+XMbNpRh3pm5DhqNFrGg/rEHLk/84mg3sQqd
	 qGoOtS7woGspYXn7FCWWhnpfaGDKLNbR/J6K7jjxa7wcob9PfNJ6OsgEBIyHaJT/Ms
	 gyMazdqf0pplA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Fred Griffoul <fgriffo@amazon.co.uk>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jianxiong Gao <jxgao@google.com>,
	John Starks <John.Starks@microsoft.com>,
	Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH RFC v3 64/88] vfio: Add vfio_device_gmem_revoke helper
 for guest_memfd
In-Reply-To: <20261106-gmem-alternative-providers-v3-64-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-64-8484dde66a7e@google.com>
Date: Mon, 09 Nov 2026 10:33:20 +0530
Message-ID: <yq5av766tx47.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 127A0180003
X-Rspamd-Server: rspam12
X-Stat-Signature: gxiy3hshj8ym94b9ww1gys647yit5599
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794200611-692665
X-HE-Meta: U2FsdGVkX1/DhIUi8p10ZiRoBrwg/NDCy18oz4KG9uDfe4HxpQp8u9v0K4awnetKJKxT0KYwPu1IpEMv6//9PMvd2gcZ7qOArGE2KwEiBJgUPJ3rFi/HWBsXtzdk/NLmarHIjSd032RmzCrDQLp7LA4OQuU0GDoWoELCCEOfEXrn9sR0U2mlMS33jqbfTxetVOcblYZND2jIR1Wr0jMO9g0OWZgkPKxwbb2UOemLLE45CGTMQO/JACMegKU2k21wkhkL10M09g81VUYQ2kNHBt/pFXzX8Ytez/crTbSljHEqpvf1jQNFv3PCElPGGv7kgr9AINdfy4vIQLN6/C5olV2DBtoqO3juso6GYG/NHRZNySFZ0r/lv/yZNATvNqWoXG0w6vL8tE7ShfnMSg1e0aQSrOdox/VLMyt3EQ8ZZp6C8N+PFr/aHLV7tkldqxrjDgU+GAGiu84JiU9EJ4ohe25dFD/3Dn7PEz1N6eyY15EtU+VDdz8o7Vf3YkEJ5iSpXEBMgHEZoITcOOsY6+n8SJ/dRZ4RXMgZqAxIl44IhlX6LSFdTpWaQeCjO+Cld5GpSUtPYKKeXuMN9C4s2PK9XgT6bgRcKu+chet9CGcBOTmHChCZtizhyiM7C5E22wH2gduC9x2JS4fux+XsuNc0PUOaO6bWGtu1IX39rwUOsaM9u3oMIgmEbmBULv9V7bnhOkIs05BAZEonQz0yHoX8zeTBESVsh4Wd9D6v0R9sWwzRpCzD+9Rlk6bXqUaOL6OwEBd8fXBIBmnh2kdtSuj2jiFTvJYrM7J2evbKtp4IwEWwAQuGTJKJq1LyXJiJw/65BhR8F/SucXoJEGqoZKrTOD/fqXWHJUleWBRLwKcRwMZEj5WUAUI4kPsZubg0UL3Kc0k41rYIlaGwUw77rumc2xHkPMPsNl24FAmwk47HfaT/o5Rrm87CCzpaElJQ3I5LzorbtC8BidjtKEOgKe/
 3PU1R8yL
 XJTXNDjcEamdZAe9fXaRHrcHEaWm12EyOToY7cvXs7+yZZllwTW0R1s8nxRzWDM/JCmX5IoW2KFnbQeSpU16Saab1RqXorWsdl8G5wjIio0t2bKApyRgZZBeakedr9X/ye3tYPtJKMuFvvB6I0l9YetOc7sKWWOMZNKYRREwQgLAL9x9WwL72Eb/46uzms4aiSw28wK0Q/8fj94J0YW/k1xJ0OwLHL9fsjVIyW7vxEKuIk3cPOix6u4iL/I2CGox2IEhcEyipiUCYRiQUB8Tf8heeueXHT1mmasj8xepsRYuGe7MGREA7jvxj6dDGz0awEMe6/V1V8W20dalexrQXFC8eKe5+tlb0kZSnw3vAc/mhz1bvyz5elOaIhZpP4XsefQvU/b+fY2JDm1ZxgINPlY8n5nRYXL5kcB0gTTR50YM+OgNjxIZWwEWwxuPPaSpQ5K3CjXBZ2y6wYrF+VbGDqyqBRqlvvab5+16GrRA2p49HymfKSlkSi3ir1oBQHxp/UzqOOATL0CqJ6RegKv3vAgBrYyHjtjMOkJxnDPGlOFyqEtrdL6g+fdqOK9jA+VS6Gryh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Ackerley Tng <ackerleytng@google.com>
>
> When physical device regions backing guest_memfd memory must be revoked
> due to hardware reset, power state transitions, or memory decode state
> changes, the bus driver must revoke and reclaim the memory ranges from
> guest_memfd before modifying hardware state.
>

Should we prevent such operations while the VFIO fd is attached to
guest_memfd? Some of these operations can transition the device to the
TDISP error state, and we should avoid host operations that can result
in vfio_pci_zap_bars().

-aneesh


