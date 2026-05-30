Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CBB2CD6E4A
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 04:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1487B6B0005; Sat, 30 May 2026 00:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA4F6B0088; Sat, 30 May 2026 00:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BDC6B008A; Sat, 30 May 2026 00:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4D306B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 00:13:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58491120329
	for <linux-mm@kvack.org>; Sat, 30 May 2026 04:13:00 +0000 (UTC)
X-FDA: 84822765720.23.10C15F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC6CD100003
	for <linux-mm@kvack.org>; Sat, 30 May 2026 04:12:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltX7AQMZ;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780114378; a=rsa-sha256;
	cv=none;
	b=hOBJpY7WSo5JQqOO+4OoFvN3E/gyqz9V9LskK4I8oJhFTHTPCL1VtRnaLAfcji/ivrLE0S
	2xisfBs/uC0heBXufTjvQzrZh2VULDait6TePaOwWU271wg5WRAtJYXUzafybwkdUe8o/A
	0PvWXzX34YYCSaHUUv1243RHKpOx44o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltX7AQMZ;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780114378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJ2+EZAPI0Sx6PGLVWMK7o62qC1Hy8xswXPruahtFwE=;
	b=yAEk1whOdquRlcY355B+GTN5xt3KvBRfRcuNjXuwGt3gHPAkqZQIgq8Ade4xE7gHt8WW1i
	p0tt6BmVjyNhSxFPffkUBWtZCqsKoA3ejD6/1uNT7o/aTPvTMkTIXorz7ZwZc7oA+kvtCz
	gABA5xUsdIT8FyZEbDJDIwEMAlutxoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37A4F601E4;
	Sat, 30 May 2026 04:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421751F00893;
	Sat, 30 May 2026 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780114377;
	bh=gJ2+EZAPI0Sx6PGLVWMK7o62qC1Hy8xswXPruahtFwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ltX7AQMZ8B8K2m+aqlHoQhv95lTG3YT2ZkMsIM3T+2lSLyBv3K3m9igwr03zn+kg2
	 3pfFk+NovLHqf9skB3ibjGAPPUKdiIzqJiGMeFinBTpGqsqeGdvZVr2WuGWleWOfdK
	 ApL2ACsaB2jWONxG3yu0jz1pnpp8/TiQ+JN9hdXDIX/weq8uBDP1B6aRUDu0p6LB6M
	 lM1HIQD7PugB5fzpiKQMNedvH0oYvJPVN//3KydsV9w4KT2/1U9aTZfyTR1rE6ag5r
	 oLNghM8FQ/80kRsH070bEGXevLVLSAyAu0ds9HUb9a0/dfl7t48QLBN/JtA3qyFQfW
	 YkFWCvbV3OiYg==
Message-ID: <7f62762d-fd91-4c07-9917-7d977441e17e@kernel.org>
Date: Sat, 30 May 2026 13:12:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 bpf-next 0/4] bpf,slab: Introduce bpf_arena_alloc()
 kfuncs
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, david@kernel.org, tj@kernel.org,
 roman.gushchin@linux.dev, peterz@infradead.org, linux-mm@kvack.org,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YOgatyp4BDKWzraBvFYgBCBj"
X-Rspam-User: 
X-Rspamd-Queue-Id: BC6CD100003
X-Rspamd-Server: rspam03
X-Stat-Signature: d9kc6ktiaonsycoo3xks596chzbnsh66
X-HE-Tag: 1780114378-240558
X-HE-Meta: U2FsdGVkX1+tgCrrrcKksWpF3DFj0s7n12IkYJxfOxujTLdZldRKYWYq9n2z1K9xYCj++HXTgkgwpuw6wtzHzw/rdgVARSsJ/drDCvc08BtQiRYgJw65KHkCVm5UiacVaJhWsAQAxPas1zTF25m3zI+zWoEio8TY7C4fCZKbDA3CJSKcjTO3zelvNrfipt9+GF4wVZbYCEwnjz+f+ERNjF8j/tIFuBpKUdZOxrAQURib9oDvO3jczneZicO8UoIyhl9zWoK+vl6SFZ3Sn22Qev40l96V0pLa1fNKUe0wAf9Yk5C7Agfeis95QhAk7rx1AlJ5LQg6BoLkve2oaWn2jzyq6oox8N0D+WTzVQ19c6UXbhn5xEQzmrFBcu5yAmniNr6/wDjZI+e3GrRfhkuhCOTvmQuA5X+QsUem8xjXxWBangtNkGJbZC8YI6dV12dhC93EXyOaSR17eLmTCTaAPXgbo9pVvCz8H7EyfyDRETaXhmWZKlyW32uCeAFjcnIvcQW7+rDzRDpkak+JGFuMESoZQiZpcOWQOX95ZSmjpyuZiaiPhnjjIiKsvrKJrtaHDY+7xEO29LxdEah7lZ9VMwmvtW/b2wWwuCtW3AUrn+SqFqD2ySEXuN62CltpNUPWJaZBHtK2NdT/Es/EG0s6UiULoY+mHh/lKc8RlAxMj/qHHslrcJ5lMyykIS5wH9l0o6Hf/YiQhKY0pZUN2WxwNBN7GaCNxd/glHsvBJPHnMuPNyylnCKy+1UeshC/rjKSXTBIJtYZTRt6cXEvhrcmxlLgWi6uv3LvjTRFeeDm94eTzZxGP9IoOoLROz2Y3rgD5/1QlcZDIqn4UneElo/ZOuVGtWg0WAVq6DQROgBDk//yY+afAeqaSG5ik3T+/kUDC6EH9hS4YPy7DDdUMVgMtT/29I9E67vSabvmsdvib4OGAHrso/5wNh1Q33D1obT3K4e+Ey/TrNFCR1hzIw1
 IsQgi/JI
 eXSply0zOmO1H9Pc9INfmJIRUaVhaBVwRwWTtLmKymNTDEUJB8IrrmtPEQmn7KFMhkmeMkne6Ytj0GJgfOkKAjSPPR7wZlX0WQ0Ax5N7OwxkqLX47aKWcfoiN51WESHhDCpyYmoJ0u5/aAyqTzmV0wItncc4aF6cjWSemqwMxLEB2I5RNxHQBeQ/sreHdq07QDmvz3JMlapjulBIzFYJjt9Bn+hJwmCBD9qfh5v2LOPF9EfpvRii2haXf/hIQmh9RsUIw3P8lNq3BnZoncBBHmhb15whQtxWsmig1alSg0scDh3oew/W7C/20u4lF2xiVKlIyLnu8lXrvTT5l5nOfej8Hi6u+VtRMn/pq60pgAEF03/jEdY/JdKrLPeLmFQq42BH1J6b5PPfCwOJvZ9dJPrOO16jUOuy9dy1UDRJqjpgbZVf74/PlStlPuKW1rU9LEav61u8v7TRu5o0UN0tLe7Q9P05hW/T9DXDt8kbY2SJYw+XJ0ItJdlVdEkKxkmp3R+PoilU4oGdsIqEYW3JLQbM+gwal10hDInE1P7Dyjnh8cHEFveIhjHRmQFNJdM5hoDnkEJZvNEN5Ls034Tj88cIcSNRzMvAM0UjnkYfgjCaDsECIpOP9r/Fkuo7PlN/msmNNdGJBIajnx2XUXvVTL306W1/VJD6xtvBOnZAzIYkM/HODkxfLVcoE6Yh/LDdh0l70x8P3hJq2SiVpwHgOF4lNxAu1s+fY+dU0J6OdWs5Ha8WVjK/30aHEk+70gsJXe2WC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YOgatyp4BDKWzraBvFYgBCBj
Content-Type: multipart/mixed; boundary="------------AQ60e9pqNWOGDjhFSvs08E9C";
 protected-headers="v1"; hp="clear"
Message-ID: <7f62762d-fd91-4c07-9917-7d977441e17e@kernel.org>
Date: Sat, 30 May 2026 13:12:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 bpf-next 0/4] bpf,slab: Introduce bpf_arena_alloc()
 kfuncs
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, david@kernel.org, tj@kernel.org,
 roman.gushchin@linux.dev, peterz@infradead.org, linux-mm@kvack.org,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260530011345.99342-1-alexei.starovoitov@gmail.com>

--------------AQ60e9pqNWOGDjhFSvs08E9C
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

W1JlcGxhY2luZyBWbGFzdGltaWwncyBhbmQgbXkgb2xkIGVtYWlscyB3aXRoIG5ldyBvbmVz
LCBhbmQgQ2MnaW5nDQogICBIYW8gTGksIHdobydzIGEgbmV3IHJldmlld2VyIGluIHRoZSBz
bGFiIHN1YnN5c3RlbV0NCg0KQSBiaXQgb2YgYmFja2dyb3VuZCBmb3IgTU0gZm9sa3Mgd2hv
IG1heSBub3QgYmUgZmFtaWxpYXIgd2l0aCBCUEYgc3R1ZmYgDQooaW5jbHVkaW5nIG15c2Vs
ZiEpLiBQbGVhc2UgY29ycmVjdCBtZSBpZiBJJ20gbWlzdW5kZXJzdGFuZGluZy4NCg0KQlBG
IGFyZW5hIFsxXSBpcyBhIDRHaUIgYXJlYSBzaGFyZWQgYmV0d2VlbiB1c2Vyc3BhY2UgYW5k
IEJQRiBwcm9ncmFtcy4gDQpUaGUgQlBGIGFyZW5hIGNhbiBiZSBzcGFyc2VseSBwb3B1bGF0
ZWQsIGFuZCB0aGVyZWZvcmUgdGhlIGtlcm5lbCBjYW5ub3QgDQphc3N1bWUgaXQgY2FuIHJl
bGlhYmx5IGFjY2VzcyBpdC4gKFRoZXJlIGlzIGEgcGF0Y2hzZXQgZnJvbSBUZWp1biB0aGF0
IA0KYWRkcmVzc2VzIHRoaXMgWzNdKS4NCg0KU2luY2UgQlBGIHByb2dyYW1zIGludGVyYWN0
IHdpdGggdGhlIGtlcm5lbCB0aHJvdWdoIGtmdW5jcyBhbmQgDQpzdHJ1Y3Rfb3BzIGNhbGxi
YWNrcywgaWRlYWxseSB0aGUga2VybmVsIHdhbnRzIHRvIHNoYXJlIGtlcm5lbCBvYmplY3Rz
IA0Kd2l0aCBCUEYgcHJvZ3JhbXM7IGhvd2V2ZXIsIHlvdSBjYW4ndCBwdXQga2VybmVsIHBv
aW50ZXJzIGRpcmVjdGx5IGluIA0KdGhlIGFyZW5hLCBhcyB0aGUgdmVyaWZpZXIgd29uJ3Qg
YWxsb3cgZGlyZWN0bHkgYWNjZXNzaW5nIHRoZW0gWzJdLiBTbyANCnRoZSBrZXJuZWwgaW5z
dGVhZCB3YW50cyB0byBhbGxvY2F0ZSBvYmplY3RzIGZyb20gdGhlIEJQRiBhcmVuYSBhbmQg
bGV0cyANCkJQRiBwcm9ncmFtcyBhY2Nlc3MgdGhlbSBkaXJlY3RseSBpbnN0ZWFkIG9mIGN1
cnJlbnQgd29ya2Fyb3VuZHMgDQptZW50aW9uZWQgaW4gWzJdIGFuZCBbM10uDQoNCnNjaGVk
LWV4dCBpcyBnb2luZyB0byB1c2UgYSBnZW5fcG9vbCBiYXNlZCBhbGxvY2F0b3IgWzNdIHRv
IGFjaGlldmUgDQp0aGF0LiBJdCB3b3JrcywgYnV0IHdlIG5lZWQgYSBtb3JlIGVmZmljaWVu
dCBhbGxvY2F0b3IgZm9yIEJQRiBhcmVuYXMgDQp3aXRob3V0IHJlLXdyaXRpbmcgdGhlIHNs
YWIgYWxsb2NhdG9yIGZyb20gc2NyYXRjaC4NCg0KVGhpcyBwYXRjaHNldCBhY2hpZXZlcyB0
aGF0IGJ5IGVuYWJsaW5nIFNMVUIgdG8gYWxsb2NhdGUgb2JqZWN0cyBmcm9tIA0KcGFnZXMg
dGhhdCBhcmUgbWFwcGVkIHRvIHRoZSBCUEYgYXJlbmEuIFNpbmNlIHRoZSBrZXJuZWwgY2Fu
bm90IGFjY2VzcyANCnRoZSBCUEYgYXJlbmEgZGlyZWN0bHkgKGF0IGxlYXN0IGZvciBub3cp
LCBTTFVCIGFsd2F5cyBhY2Nlc3NlcyBvYmplY3RzIA0KdmlhIHRoZSBkaXJlY3QgbWFwIHdo
aWxlIEJQRiBwcm9ncmFtcyBhY2Nlc3MgdGhlbSB2aWEgdGhlIHZtYWxsb2MgDQphZGRyZXNz
IHNwYWNlIChrZXJuX3ZtX3N0YXJ0KS4NCg0KR2l2ZW4gdGhhdCBCUEYgcHJvZ3JhbXMgY2Fu
IGFjY2VzcyBzbGFiIHBhZ2VzIGluIHRoZSBCUEYgYXJlbmEgDQoodXNlcnNwYWNlIHByb2dy
YW1zIGNhbid0LCBzZWUgYXJlbmFfdm1fZmF1bHQoKSksIG9uZSBpbnRlcmVzdGluZyBhc3Bl
Y3QgDQp3b3VsZCBiZSB0byBtYWtlIHN1cmUgdGhlIGtlcm5lbCBhdm9pZHMgcGFuaWNraW5n
IGFuZCBmYWxscyBiYWNrIA0KZ3JhY2VmdWxseSBpbiBjYXNlIG9mIGVycm9ycyBpbiB0aGUg
c2xhYiBwYWdlICh3aGlsZSBtYWludGFpbmluZyANCnJlYXNvbmFibGUgcGVyZm9ybWFuY2Us
IG9mIGNvdXJzZSkuDQoNClsxXSBodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvOTYxOTQxDQpb
Ml0gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzEwMTk4ODUNClszXSBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC1tbS8yMDI2MDUyMDIzNTA1Mi40MTgwMzE2LTEtdGpAa2VybmVs
Lm9yZw0KDQpJJ2xsIGdldCB0byBpdCBhbmQgcmV2aWV3IHNvb24uDQoNClRoYW5rcy4NCg0K
LS0gDQpDaGVlcnMsDQpIYXJyeSAvIEh5ZW9uZ2dvbg0KDQpPbiA1LzMwLzI2IDEwOjEzIEFN
LCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+IEZyb206IEFsZXhlaSBTdGFyb3ZvaXRv
diA8YXN0QGtlcm5lbC5vcmc+DQo+IA0KPiB2MS0+djI6DQo+IC0gZGlzYWJsZSBrYXNhbiBm
b3Igc2xhYi1hcmVuYQ0KPiAgICBOb3RlLCBwYXRjaCAxIHJlbGllcyBvbiBwYXRjaCAzIGZv
ciBjb3JyZWN0bmVzcy4NCj4gICAgSSBkaWRuJ3Qgc3F1YXNoIHRoZW0sIHNpbmNlIGl0J3Mg
ZWFzaWVyIHRvIHJldmlldyB0aGlzIHdheS4NCj4gLSBmaXggaXNzdWVzIGZvdW5kIGJ5IHNh
c2hpa28NCj4gdjE6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2JwZi8yMDI2MDUyOTIw
MjQzOC4xNjQwOC0xLWFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20vDQo+IA0KPiBMZXQg
QlBGIHByb2dyYW1zIGFuZCBrZXJuZWwgYWxsb2NhdGUgb2JqZWN0cyBpbiBicGYgYXJlbmEg
dmlhDQo+IGt2bWFsbG9jLXN0eWxlIEFQSTogYnBmX2FyZW5hX2FsbG9jKCkga2Z1bmMuDQo+
IA0KPiBDdXJyZW50bHkgc2NoZWQtZXh0IEJQRiBwcm9ncmFtcyBpbXBsZW1lbnQgdmFyaW91
cyBhbGxvY2F0b3JzDQo+IGFzIEJQRiBwcm9ncmFtcyBvbiB0b3Agb2YgYnBmX2FyZW5hX2Fs
bG9jX3BhZ2VzKCkga2Z1bmMuDQo+IFRoaXMgaXMgaW5lZmZpY2llbnQuDQo+IA0KPiBSZWNl
bnRseSBzY2hlZC1leHQga2VybmVsIGNvcmUgaW50cm9kdWNlZCBzY3hfYXJlbmFfYWxsb2Mo
KSBiYWNrZWQNCj4gYnkgZ2VuX3Bvb2xfYWxsb2MoKSB0byBhbGxvY2F0ZSBhcmVuYSBtZW1v
cnkgdG9vLg0KPiBUaGlzIGlzIGFsc28gaW5lZmZpY2llbnQgYW5kIGdlbl9wb29sX2FsbG9j
KCkgaXMgbm90IGZhc3QgZW5vdWdoLg0KPiANCj4gSGVuY2UgYWRvcHQgc2hlYXZlcyBhbmQg
c2x1YiBhcyBhbGxvY2F0b3IuDQo+IFNlZSBwYXRjaCAzIGZvciBhbGdvcml0aG0gZGV0YWls
cy4NCj4gDQo+IEFsZXhlaSBTdGFyb3ZvaXRvdiAoNCk6DQo+ICAgIHNsYWI6IEludHJvZHVj
ZSBrbWVtX2NhY2hlX2FsbG9jX2FyZW5hX25vbG9jayBhbmQga2ZyZWVfYXJlbmFfbm9sb2Nr
DQo+ICAgIHNsdWI6IFBhc3Mga21lbV9jYWNoZSB0byBhbGxvY19zbGFiX3BhZ2UoKQ0KPiAg
ICBicGYsc2xhYjogQWRkIHNsdWItYmFja2VkIGFsbG9jYXRvciBmb3IgYnBmX2FyZW5hDQo+
ICAgIHNlbGZ0ZXN0cy9icGY6IEFkZCB0ZXN0cyBmb3IgYXJlbmEgc2x1Yi1iYWNrZWQgYWxs
b2NhdG9yDQo+IA0KPiAgIGluY2x1ZGUvbGludXgvYnBmX2RlZnMuaCAgICAgICAgICAgICAg
ICAgICAgICB8ICAxMyArDQo+ICAgaW5jbHVkZS9saW51eC9zbGFiLmggICAgICAgICAgICAg
ICAgICAgICAgICAgIHwgIDI1ICsrDQo+ICAga2VybmVsL2JwZi9LY29uZmlnICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICAzICsNCj4gICBrZXJuZWwvYnBmL2FyZW5hLmMgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCA0MjUgKysrKysrKysrKysrKysrKystDQo+ICAg
bW0vc2xhYi5oICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA2ICst
DQo+ICAgbW0vc2xhYl9jb21tb24uYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAyICstDQo+ICAgbW0vc2x1Yi5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgMjY2ICsrKysrKysrKystDQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0
cy9hcmVuYV9zbGFiLmMgICAgIHwgIDU5ICsrKw0KPiAgIC4uLi9wcm9nX3Rlc3RzL2FyZW5h
X3NsYWJfZnJlZXB0cl9zdGFsZV9wY3MuYyB8ICAyOCArKw0KPiAgIC4uLi90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvcHJvZ3MvYXJlbmFfc2xhYi5jICB8IDE3OSArKysrKysrKw0KPiAgIC4u
Li9icGYvcHJvZ3MvYXJlbmFfc2xhYl9mcmVlcHRyX3N0YWxlX3Bjcy5jICB8IDEyMCArKysr
Kw0KPiAgIDExIGZpbGVzIGNoYW5nZWQsIDEwODggaW5zZXJ0aW9ucygrKSwgMzggZGVsZXRp
b25zKC0pDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi9wcm9nX3Rlc3RzL2FyZW5hX3NsYWIuYw0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9hcmVuYV9zbGFiX2ZyZWVw
dHJfc3RhbGVfcGNzLmMNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dzL2FyZW5hX3NsYWIuYw0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0
NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvYXJlbmFfc2xhYl9mcmVlcHRy
X3N0YWxlX3Bjcy5jDQo+IA0KDQo=

--------------AQ60e9pqNWOGDjhFSvs08E9C--

--------------YOgatyp4BDKWzraBvFYgBCBj
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEARYKADkWIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCahpjuBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwwLDMACgkQhlwTeq3OUtbHqAEAr+J/oR6rZ39dfikTiEo1
ucg13hc44kaKPwJW55DbiE8BALL0Z+VBQjT3buxlL9CZJShwvMEIN01zUj7ga1NT
fmgO
=H9v7
-----END PGP SIGNATURE-----

--------------YOgatyp4BDKWzraBvFYgBCBj--

